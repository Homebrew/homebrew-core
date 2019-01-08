class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.17.tar.gz"
  sha256 "3c5a718731c90a75a1134796ab9de9a0156f6b3a8d1dec4f532e161b94bdaff4"
  revision 1

  bottle do
    cellar :any
    sha256 "e2f6aabed324721e31798315e0f8f7768f14b3858e6b16f4f921edb57ff40838" => :mojave
    sha256 "0ebbe3c416cd433966a37d6724129720a1314e9a0f9b58ef3ff132ece9d8efb3" => :high_sierra
    sha256 "ea3328cb0ffa8848a1f21893ee96782bd886cd9821d0e4542968b98c7c209cf7" => :sierra
    sha256 "cb6ada311bc269985934cc835adf7dde8e8437f882beda9223ba47613c5364f0" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  # Python 3 error filed upstream: https://github.com/sshock/AFFLIBv3/issues/35
  depends_on "python@2" # does not support Python 3
  depends_on :osxfuse => :optional

  def install
    args = ["--enable-s3", "--enable-python"]

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
