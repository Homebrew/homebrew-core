class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.18.0",
      revision: "28ef289f027713cb024e3171ccfa2972fc12a9e2"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9986332ca0bfad47381c4c7db8ee335a35c98970ce500bd229e6b7e8b81815af"
    sha256 cellar: :any,                 arm64_ventura:  "b597244b6582f0b11d78a5d09584187d0f4e91904ca31bb7c1c27e740f9386f9"
    sha256 cellar: :any,                 arm64_monterey: "4f927b09a5f36609aaca9fb05a5b7c90de7f7110b89c3a4638f0b6a3f52278db"
    sha256 cellar: :any,                 arm64_big_sur:  "e5e64ff901c6842bb30afaaf9a9d41dc18f06c400aed883e55837da4f3d026e4"
    sha256 cellar: :any,                 sonoma:         "2bb1bbd7c56578d67e2d5db6bcfa56bff370bcfe2be6fec476f7580d73d456b8"
    sha256 cellar: :any,                 ventura:        "4900c1cec8804adf465c48dfca4d66d39972bf28fd2e5f56c0b1277c614f46e9"
    sha256 cellar: :any,                 monterey:       "91dabc893fcb61fd8d850a04ecdee77b77f27b04093b8e86a3228a8c9bc2124b"
    sha256 cellar: :any,                 big_sur:        "592682de3fcff95f7798d27796ca9ccf6d206eccee2e922811ea3fe80ccfb017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e212c9f201ba61355643d3387b1075520a58939109d49fe98debf3463602da"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  # Fix compilation on Linux. Remove in the next release.
  patch do
    url "https://github.com/cloudflare/quiche/commit/7ab6a55cfe471267d61e4d28ba43d41defcd87e0.patch?full_index=1"
    sha256 "d768af974f539c10ab3be50ec2f4f48dc8e6e383aab11391a4bfcd39b7f49c34"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/#{shared_library("libquiche")}"
    include.install "quiche/include/quiche.h"

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
