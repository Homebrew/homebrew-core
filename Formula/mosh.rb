class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 6

  bottle do
    cellar :any
    sha256 "70ca7ccdb7df9a452d9968cbf5b6da4f9fb3be7cb5c175ab5117b1e4cff7b985" => :mojave
    sha256 "9ea48721b704ca8a2d14c285c406a6d74e549f1b0e3ef46c39483ff4ac50f530" => :high_sierra
    sha256 "742f74281cf18e9f7d435a805d1d554e2e8882849ddef32e1e54d794144c9ba3" => :sierra
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build
  depends_on "protobuf"

  # Fix mojave build.
  patch do
    url "https://github.com/mobile-shell/mosh/commit/e5f8a826ef9ff5da4cfce3bb8151f9526ec19db0.patch?full_index=1"
    sha256 "022bf82de1179b2ceb7dc6ae7b922961dfacd52fbccc30472c527cb7c87c96f0"
  end

  def install
    ENV.cxx11

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
