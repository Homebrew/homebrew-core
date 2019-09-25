class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.8.0/+download/flowgrind-0.8.0.tar.bz2"
  sha256 "2e8b58fc919bb1dae8f79535e21931336355b4831d8b5bf75cf43eacd1921d04"
  revision 1

  bottle do
    cellar :any
    sha256 "6f553df17bf8ca8bd2310d7cbe39f69a0e84d340f38a670dbed8e03b86557faf" => :mojave
    sha256 "754e48c27b802daade1c09ccf26ca7cb86f087291143733b421a3fc4817cabe0" => :high_sierra
    sha256 "2f1c5c10ceae40a7fd7c377a1d2d76f28942728f7b7224ff05c6bab00b01231b" => :sierra
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
