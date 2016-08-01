class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.mit.edu/"
  revision 1

  stable do
    url "https://mosh.mit.edu/mosh-1.2.5.tar.gz"
    sha256 "1af809e5d747c333a852fbf7acdbf4d354dc4bbc2839e3afe5cf798190074be3"

    # Upstream switched to defaulting to CommonCrypto as of
    # https://github.com/mobile-shell/mosh/commit/0eb614809a7ea
    depends_on "openssl"
  end

  devel do
    url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.2.5.95rc1/mosh-1.2.5.95rc1.tar.gz"
    sha256 "a2697c41cfc8c92dc7a743dd101849a7a508c6986b24d6f44711d8533d18fcf5"

    depends_on :perl => "5.14" if MacOS.version <= :mountain_lion
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on :perl => "5.14" if MacOS.version <= :mountain_lion
  end

  option "without-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/mosh-client", "-c"
  end
end
