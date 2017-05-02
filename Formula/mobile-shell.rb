class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.0.tar.gz"
  sha256 "320e12f461e55d71566597976bd9440ba6c5265fa68fbf614c6f1c8401f93376"

  bottle do
    sha256 "6ab4f7e7cf8e149f10931471658063356b485b0ca34037f44c93afaae34c1c0f" => :sierra
    sha256 "86daec2c4d1517f4485989c69f989caf1a16fdc891cb2f4a949371bd5b4eeda0" => :el_capitan
    sha256 "398f486fc155ba3e345bd26834b4bff6c16e0535237e196cb766cf472fc3811b" => :yosemite
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on :perl => "5.14" if MacOS.version <= :mountain_lion
  depends_on "tmux" => :build if build.with?("test") || build.bottle?

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
