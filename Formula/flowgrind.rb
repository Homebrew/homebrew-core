class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.8.0/+download/flowgrind-0.8.0.tar.bz2"
  sha256 "2e8b58fc919bb1dae8f79535e21931336355b4831d8b5bf75cf43eacd1921d04"
  revision 2

  livecheck do
    url :stable
    regex(%r{<div class="version">\s*Latest version is flowgrind[._-]v?(\d+(?:\.\d+)+)\s*</div>}i)
  end

  bottle do
    cellar :any
    sha256 "631e7fc8316f75178ac6d6dd82f750ccd5d61b60be2d02735af82f3a19009ccd" => :big_sur
    sha256 "04abc2739f06a85e452a618cf1eb5ec3fdb4ebd3e70840a58c2ee74815c6838d" => :arm64_big_sur
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
