class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://github.com/jorisvink/kore/releases/download/2.0.0-release/kore-2.0.0-release.tar.gz"
  sha256 "b538bb9f4fb7aa904c5f925d69acc1ef3542bc216a2af752e6479b72526799f5"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "de46884ed40584d4d19654ad6c73ccbc363d8124c4d5146f7f9cb3a88e5bfda2" => :el_capitan
    sha256 "ce954b26de131904e013468ca9bca6fd87322be46d4698c2a16b6fb948b4ad6f" => :yosemite
    sha256 "19ad4950c7979c18ec09aef4433ec2ca09269f6669a8505f4ad438691b4252b0" => :mavericks
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
