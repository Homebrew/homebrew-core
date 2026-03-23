class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/refs/tags/v4.3.5a.tar.gz"
  version "4.3.5a"
  sha256 "bca78a2076ebb02179f93ab6cf2363b1256d878b540f810c238ea231ad5948ab"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87537dd8d3d18b25f365590bba0f0bbd2213564550648cb9216d715c5c3cc7bf"
    sha256 cellar: :any,                 arm64_sequoia: "1f236f253e71cbaf92741c2962ef91002a18b14d94b7173f9198ea7fa033708a"
    sha256 cellar: :any,                 arm64_sonoma:  "39f9d7f64997c687db7dfdc9021f93b89855722bd42083439bc5e47f159d3c43"
    sha256 cellar: :any,                 sonoma:        "ab6cfab4f8c71b7d660afff59fb24b4dcb53fbee213bbe9d671e15ad9fe705b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "455b960a284815a66eb7097a40641a8ebb2cffce774dc28235f18b2db44de5b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4270feb490a55243e8e47674212ab7492e0a8287df66ec88e07c368e2675dd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-manpages", "--disable-doxygen", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    spawn bin/"coap-server", "-p", port.to_s
    sleep 1
    output = shell_output("#{bin}/coap-client -B 5 -m get coap://localhost:#{port}")
    assert_match "This is a test server made with libcoap", output
  end
end
