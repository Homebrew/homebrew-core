class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://github.com/jorisvink/kore/releases/download/2.0.0-release/kore-2.0.0-release.tar.gz"
  sha256 "b538bb9f4fb7aa904c5f925d69acc1ef3542bc216a2af752e6479b72526799f5"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "533aba9652749af143e213d66217d4330d7e5829334cd5258c22437266e78468" => :sierra
    sha256 "226f73e82833adaecc36f648c742619b4ae8795f2fb30fc77c6e37cd5c9e73f1" => :el_capitan
    sha256 "d6f89fc8e1527340fe295bc916327b1d41baf97dd5f0c8cd1f3f4b92c39c3da3" => :yosemite
  end

  # src/pool.c:151:6: error: use of undeclared identifier 'MAP_ANONYMOUS'
  # Reported 4 Aug 2016: https://github.com/jorisvink/kore/issues/140
  depends_on :macos => :yosemite

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
    system bin/"kore", "create", "test"
    cd "test" do
      system bin/"kore", "build"
      system bin/"kore", "clean"
    end
  end
end
