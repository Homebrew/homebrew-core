class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.17.2",
      revision: "a4ac85642eca40e45cc6e0cfd916d55b81537e2c"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "024896f069b2bc14a441b3e912c319af7734687f65f2e1c0deca12a8287403f2"
    sha256 cellar: :any,                 arm64_monterey: "abf2685d3a2aa8cc9299edcf66135423d4cebad5c462e2b705f4906e118bbcb9"
    sha256 cellar: :any,                 arm64_big_sur:  "18f7b6b69ff943f5beea078d2037f8e14eadaf07d7b336d94df83d0efed965b0"
    sha256 cellar: :any,                 ventura:        "3a790ca5670f07069c376351a5ee3e55906df9de84a4f8d695aa362aa2e770d5"
    sha256 cellar: :any,                 monterey:       "7bab419d9e3b48e1455440a73ed92fa7cd4843181ac67edccd0239f98c23f104"
    sha256 cellar: :any,                 big_sur:        "db850a1b1a9d233d62ae8d0d21956e230ba215c0a7f7cd71897d8e3dce680107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f48478a7bc849839c02d3a836cedb4b0b4f016f0bc2d464613007e5af4801cd"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--offline", "--lib", "--features", "ffi", "--release"
    lib.install "target/release/#{shared_library("libquiche")}"
    include.install "quiche/include/quiche.h"
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
    (testpath/"test.c").write <<~EOS
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end
