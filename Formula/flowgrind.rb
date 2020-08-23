class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.8.0/+download/flowgrind-0.8.0.tar.bz2"
  sha256 "2e8b58fc919bb1dae8f79535e21931336355b4831d8b5bf75cf43eacd1921d04"
  revision 2

  bottle do
    cellar :any
    sha256 "e598d94bf046253c93bfb394d532584bca417b69e63b70b851f0ab4f9adf3089" => :catalina
    sha256 "652a07d073f21ae8158fed8b7a34c739a88a0e594c32408a83d48e80a93df944" => :mojave
    sha256 "4b723ca4f7f92a354bf8226d67fd8537a13c07223ff5d05ebd9da82491cb546a" => :high_sierra
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end
