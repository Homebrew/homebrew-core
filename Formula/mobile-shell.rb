class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.mit.edu/"
  url "https://mosh.mit.edu/mosh-1.2.6.tar.gz"
  sha256 "7e82b7fbfcc698c70f5843bb960dadb8e7bd7ac1d4d2151c9d979372ea850e85"
  revision 1

  bottle do
    sha256 "325c5eec28ad8f47a36bb90811f60ae8d9279b2c176711b26a3bbaa6cf6f62f5" => :sierra
    sha256 "3bd5f25f012d62a0a7dfcaa0e9cd342719f096bf7ee637219748d87eb651b4de" => :el_capitan
    sha256 "0d53e1fc24940f34eceac6921ea3aef4bbcf604c874c9203263ad720655242ed" => :yosemite
    sha256 "64ad8f75f9a8aa23d5ee9eeedc61f730bbdf4efd943c7f555cf6966b64eff4cb" => :mavericks
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
    system bin/"mosh-client", "-c"
  end
end
