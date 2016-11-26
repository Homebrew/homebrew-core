class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.11.tar.gz"
  sha256 "931a6f3399c6397a4ac2d84664d80d7ae3e81de55f98e781ac43319cabfedeb7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "46c9fbfab349dbda7b1c0c6471d71e896154c65a68e7b50a93ae35b5d1f8c67d" => :sierra
    sha256 "72864322573f03f56889c9d5d06ffe9b4204d4295d47ba17e4aa195c96b75b70" => :el_capitan
    sha256 "ce2ec042b4841e8a336e5057830bd479a0c33369352865bd12f2b0ca097594a7" => :yosemite
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
