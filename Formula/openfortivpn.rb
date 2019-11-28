class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.11.0.tar.gz"
  sha256 "95db77566376f4504547b6407b249f007f2edf63b85ffe999436a999569645b6"

  bottle do
    sha256 "396009d63b652565101cc5dc0e2c6fddcb69ddb6440d728c94952cd0f16f15a4" => :catalina
    sha256 "4ba2c3ca99e7f799a74e4e0fdf9b755681309297bd1dd6237d076ea4a0caeb59" => :mojave
    sha256 "9ad39cc736a5eb30e3d6cc077deb5a5fbe3edca01b16d6f50fee87740dce2bf8" => :high_sierra
    sha256 "7914365ffec1cdb05e19c776557d5cbde976f2930dae3397428e8c254103d781" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
