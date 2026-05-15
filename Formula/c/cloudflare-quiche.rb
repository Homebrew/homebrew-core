class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.29.0",
      revision: "e85fc8e8082e5ab57b8c0c4a5785f1b84b39901c"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbda836ca593d2bbb1711ca97c68e043d3b7e2766ae22b52b17734295d70c9c1"
    sha256 cellar: :any,                 arm64_sequoia: "40144e609ac8705a2d97930b93ae009ebc53926040652d5e596bb5aba8590333"
    sha256 cellar: :any,                 arm64_sonoma:  "6df83e49c05c8f394ce308dc4186ed93489a424b5c5b51f9345b880585007ab7"
    sha256 cellar: :any,                 sonoma:        "7a8aca6d667c77a7ff4c9a79622121565b7783cc36428b2c523d49b6c22ec200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ff5433991db61d5ce2ebbea0c13ec2baab1149facd36a6251e632e6a6ae7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4999a62e16f08dc6ea1605659f30a397fe6fdece87587a716464fa50a402b6c3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/libquiche.a"
    include.install "quiche/include/quiche.h"

    # install dylib with version and symlink
    full_versioned_dylib = shared_library("libquiche", version.major_minor_patch.to_s)
    lib.install "target/release/#{shared_library("libquiche")}" => full_versioned_dylib
    lib.install_symlink full_versioned_dylib => shared_library("libquiche")
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major.to_s)
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major_minor.to_s)

    # install pkgconfig file
    pc_path = "target/release/quiche.pc"
    # the pc file points to the tmp dir, so we need inreplace
    inreplace pc_path do |s|
      s.gsub!(/includedir=.+/, "includedir=#{include}")
      s.gsub!(/libdir=.+/, "libdir=#{lib}")
    end
    (lib/"pkgconfig").install pc_path
  end

  test do
    assert_match "your browser used <strong>HTTP/3</strong>",
                 shell_output("#{bin}/quiche-client https://cloudflare-quic.com/")
    (testpath/"test.c").write <<~C
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end
