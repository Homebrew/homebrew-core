class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "https://www.openwall.com/passwdqc/"
  url "https://www.openwall.com/passwdqc/passwdqc-1.3.1.tar.gz"
  sha256 "d1fedeaf759e8a0f32d28b5811ef11b5a5365154849190f4b7fab670a70ffb14"

  bottle do
    cellar :any
    sha256 "e0f9450b595fb6935ed0cba174755cda95a7ff2fc7f9cc0e9e9027f69e5c1b6c" => :mojave
    sha256 "f3225da4795b1f3c89e25aac62101021f533faebe52fda91101a497da156f797" => :high_sierra
    sha256 "e63d866e12db3c5b031b33681a8a6b5163908cbbedde6d33e72e2543a4a75ef2" => :sierra
    sha256 "607a5adfb33eca79f847569357c77d643b9be4b17ba73c915575990ad676bddd" => :el_capitan
    sha256 "6aac1b96be6144cdb889af5cbcccc3c6779593f3544abdc186d17c61cc4acf34" => :yosemite
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
