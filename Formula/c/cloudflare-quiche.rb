class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.7",
      revision: "d680c81a79718c6e3eb6467349a8a6eb7c6cce3a"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "649bddf4ea4a9e6b4b9832212c2b0bc5be05ded2859d337c7dd7effb82daebb0"
    sha256 cellar: :any,                 arm64_sequoia: "c47bc09bc902616086647aa0d2b579a6d01327bfbcce3b5f2c28379d00fee8f5"
    sha256 cellar: :any,                 arm64_sonoma:  "da308103499f245f4292057df0ba65d24d42dcd8d8fbc60403749cce1dec2c82"
    sha256 cellar: :any,                 sonoma:        "a77fcd909429b79e06675b4b5105faf24b06bbe5f37496a335e1e4a4e2ac87be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd817b288af61e0994776f501aaeefa74e06aa6eb32ac45ef475a5278ba30196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f30dd008571cb4e1464a6b39bd3d250e8e5650cbb858b803c624aabd5c17334"
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
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
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
