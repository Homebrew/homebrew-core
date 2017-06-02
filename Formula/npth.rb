class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.5.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.5.tar.bz2"
  sha256 "294a690c1f537b92ed829d867bee537e46be93fbd60b16c04630fbbfcd9db3c2"

  bottle do
    cellar :any
    sha256 "04f04d92596d8900aa64db510f288f4e98d0145072b9a18fe871e060f867f5d9" => :sierra
    sha256 "5ba80bd4f49981de50ca7d29659ba8a3e35b60c69243ef8344ce8e4d1e4b171d" => :el_capitan
    sha256 "a8df8b963b69529db8328ba92b9f37c385c55a86d4b01b2a454ff7703c3187f9" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/npth-config", "--version"
  end
end
