class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.11.tar.gz"
  sha256 "931a6f3399c6397a4ac2d84664d80d7ae3e81de55f98e781ac43319cabfedeb7"

  bottle do
    cellar :any
    sha256 "c381e7bbdae4052f8dbf664a122ba879ba76c027fcbd43ab85e1241e5d147a01" => :sierra
    sha256 "088a33309187a61f5b9e2c66c005d5398ec9159bcabd623a672701242a3b77a0" => :el_capitan
    sha256 "fcde02aa5b1176477451d688bbac7fd3a0aa99e09657681a16ac37e9b2fa664e" => :yosemite
  end

  option "with-python", "Build with python support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse => :optional
  depends_on :python if build.with?("python") && MacOS.version <= :snow_leopard

  def install
    ENV.prepend "LDFLAGS", "-L/usr/lib -lcurl -lexpat"

    args = ["--enable-s3"]

    if build.with? "python"
      inreplace "m4/acinclude.m4",
        "PYTHON_LDFLAGS=\"-L$ac_python_libdir -lpython$ac_python_version\"",
        "PYTHON_LDFLAGS=\"-undefined dynamic_lookup\""
      args << "--enable-python"
    end

    if build.with? "osxfuse"
      ENV.append "CPPFLAGS", "-I/usr/local/include/osxfuse"
      ENV.append "LDFLAGS", "-L/usr/local/lib"
      args << "--enable-fuse"
    else
      args << "--disable-fuse"
    end

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
