class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "https://www.openwall.com/passwdqc/"
  url "https://www.openwall.com/passwdqc/passwdqc-1.4.0.tar.gz"
  sha256 "72689c31c34d48349a7c2aab2cf6cf95b8d22818758aba329d5e0ead9f95fc97"

  bottle do
    cellar :any
    sha256 "70f699e8f784eaecfaf60c42abc1545347a2ac7e543a3c5012c3d48fa78c8977" => :big_sur
    sha256 "9e1672f833e04b334c73027bdbec92ad00f4cf14d1f0afd836c985fd51acceb8" => :arm64_big_sur
    sha256 "79af7b94b6b1cf7063931c89285dc47440c4b1a66b273c80900e5f0b839ee527" => :catalina
    sha256 "41115da2512aa8ee6f62fdda8b822d26a63d6eeaf5496ca624adbe25b384cb55" => :mojave
    sha256 "e7da5597bd23a730aa9b28fa3e3efa749952beaa7a480959cad4e7c6a238400d" => :high_sierra
  end

  def install
    args = %W[
      BINDIR=#{bin}
      CC=#{ENV.cc}
      CONFDIR=#{etc}
      DEVEL_LIBDIR=#{lib}
      INCLUDEDIR=#{include}
      MANDIR=#{man}
      PREFIX=#{prefix}
      SECUREDIR_DARWIN=#{prefix}/pam
      SHARED_LIBDIR=#{lib}
    ]

    system "make", *args
    system "make", "install", *args
  end

  test do
    pipe_output("#{bin}/pwqcheck -1", shell_output("#{bin}/pwqgen"))
  end
end
