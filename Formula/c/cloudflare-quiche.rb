class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.28.0",
      revision: "a9cb314563a5c13791bd7e5a1e32821e53114e75"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60dc3c15924de31fcd7ff7a29dd4afaed339cbfa3c9981be83558bd7f9691dfc"
    sha256 cellar: :any,                 arm64_sequoia: "6d21db086ac21a99e0a336d2c105827973e042e886e24363d0e8d9859ad8dbd8"
    sha256 cellar: :any,                 arm64_sonoma:  "f594701107936b99fb074aeffd1c832353ffb084e8c6c1c7f31f9c990dc05445"
    sha256 cellar: :any,                 sonoma:        "fa07019f1034b88de3add0eec73a59e4792e3fc87b211378de8bed167a2c6535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a8ff6c1a3b9206cfecea3de3087b72d46a7c06c03fbaa3340f7456368a869a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67f162bb94307d4f37875cdcfc246c6bb5fb49569599c113dcd708ec8f5e3f3"
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
