class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.0.tar.gz"
  sha256 "320e12f461e55d71566597976bd9440ba6c5265fa68fbf614c6f1c8401f93376"
  revision 1

  bottle do
    sha256 "092d47a9a6836e66597775dadca0bc78c57b04879cf6c392f7514605d8c53a50" => :sierra
    sha256 "c406e65d8589855f49487feefea50166c5fb37395b07fa7c54f5882b2a5fbe2d" => :el_capitan
    sha256 "435b0730e2335d91a5317219c46f703993215333f370f1c998b0122770844e7b" => :yosemite
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
    # Remove for > 1.3.0
    # Upstream commit from 29 Apr 2017 "Disable unicode-later-combining.test for now"
    # See https://github.com/mobile-shell/mosh/commit/df4dbe0d6c9c3ac7a6a102f315090c9b7aa75ad6
    if build.stable?
      inreplace "src/tests/Makefile.in", /^\tunicode-later-combining.test \\$\n/, ""
    end

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
