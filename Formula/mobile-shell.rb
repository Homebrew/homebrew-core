class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.2.6.tar.gz"
  sha256 "7e82b7fbfcc698c70f5843bb960dadb8e7bd7ac1d4d2151c9d979372ea850e85"
  revision 4

  bottle do
    sha256 "f170b43d61fc6e9d1c38bbf4815ef7339415807ebfa560fdb5f3d8f23aeaf57c" => :sierra
    sha256 "426d82ec12f5bcde93aaf1f5a90a357e6a1c9f78dcb21894635e26e54d5f6192" => :el_capitan
    sha256 "fd01f23a2bdedf3cf182fea9737fa44a4cf1b3b39a6b522d6f7dd8c8f5c89336" => :yosemite
  end

  devel do
    url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.3.0-rc2/mosh-1.3.0-rc2.tar.gz"
    sha256 "8b6bff33c469ccea0438877c68774a6b2ded6fccd99b1db180222da82f0654ae"
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
