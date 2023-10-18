class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.18.0",
      revision: "28ef289f027713cb024e3171ccfa2972fc12a9e2"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c523f169f7a3482e4a37a9dfecbdb7ea9a4a8d74de4bbed2ab051f20bded47e5"
    sha256 cellar: :any,                 arm64_ventura:  "6880219663b65187d4b771f5891a97bc33dc1711b2c45daa0ccea3ab0a9d4751"
    sha256 cellar: :any,                 arm64_monterey: "f64c8bb6bf58c2fa0e2c2e2b8b2339a3e94e494cc37e07d28f563d3d34eb93a5"
    sha256 cellar: :any,                 sonoma:         "9e0e28a57f635622da080fd83b478716e626e356d79493d5d612666bc245907b"
    sha256 cellar: :any,                 ventura:        "d2971b6345faa94babe8cc0110e3631dcd5a69b406e49b8ad6f9c16c634ebf03"
    sha256 cellar: :any,                 monterey:       "2cb1a69dac9930c0f40076ed0739b506742182342ecdfdae774a5f551e6ca415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45295bb553be972178bc3fd21cd072d22d92f11d1cabbe04bd336aac25205394"
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
