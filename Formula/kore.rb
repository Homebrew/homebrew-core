class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-3.1.0.tar.gz"
  sha256 "3f78fb03262046ffa036a7e112dbcbc45fbfca509a949b42f87a55da409f6595"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "ba5415f507f276e25c99857270e24da3354eb784a9fb659db854987b2e467d9b" => :mojave
    sha256 "74d9babde97c58bab9e763510d60762b6be89237eb5129073b4820d31a6fe43c" => :high_sierra
    sha256 "533aba9652749af143e213d66217d4330d7e5829334cd5258c22437266e78468" => :sierra
    sha256 "226f73e82833adaecc36f648c742619b4ae8795f2fb30fc77c6e37cd5c9e73f1" => :el_capitan
    sha256 "d6f89fc8e1527340fe295bc916327b1d41baf97dd5f0c8cd1f3f4b92c39c3da3" => :yosemite
  end

  depends_on :macos => :sierra # needs clock_gettime

  depends_on "openssl"
  depends_on "postgresql" => :optional

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl"].opt_include

    args = []

    args << "PGSQL=1" if build.with? "postgresql"

    system "make", "PREFIX=#{prefix}", "TASKS=1", *args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
