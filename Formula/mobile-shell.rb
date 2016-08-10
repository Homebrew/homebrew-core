class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.mit.edu/"
  url "https://mosh.mit.edu/mosh-1.2.6.tar.gz"
  sha256 "7e82b7fbfcc698c70f5843bb960dadb8e7bd7ac1d4d2151c9d979372ea850e85"

  bottle do
    sha256 "ce0722d44de6a01bb2eeb65e57913ece2e67608220f88ce88313433774b848bd" => :el_capitan
    sha256 "58a5f78501ecfaab4111c36ef327a71f91d8a11d3cb4cacd9d72b178fe825800" => :yosemite
    sha256 "0ea2fd16afac4835561a31de56bd4550d6d4b431611543bb2a88e1437ecb3165" => :mavericks
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "without-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on :perl => "5.14" if MacOS.version <= :mountain_lion

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
