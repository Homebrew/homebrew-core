class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "http://www.openwall.com/passwdqc/"
  url "http://www.openwall.com/passwdqc/passwdqc-1.3.1.tar.gz"
  sha256 "d1fedeaf759e8a0f32d28b5811ef11b5a5365154849190f4b7fab670a70ffb14"

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
