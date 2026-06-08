class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.29.1",
      revision: "f0c7193c3b130d766f0d6f3e75d4f2405c85d376"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c85bcbcd47a06e0d435220d8ffae3d78bdff36771f89d8197c21d174b895a0f2"
    sha256 cellar: :any,                 arm64_sequoia: "d4cb9e9b2c81adac62e9a087004ec6631ad9e7082737cb07767c4177863e2d99"
    sha256 cellar: :any,                 arm64_sonoma:  "d191cd0298816f80021f986ebe29544a0d0e30763fa7ca098a1e871a7f77b842"
    sha256 cellar: :any,                 sonoma:        "a3d1aa74df9a4e29bd31c22b1a7db6c9ce37da5282b22cb8fe48aa3bc89591ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69f7f8b0d5ad66d81694c4b8a2b83925feb756c72a6169cc1c1606cd0bf3fad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f0f7e6ae2d8c5b3b15b4a89feb8e3e12fb6470db737550b346f69f59909062"
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
