class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 7

  bottle do
    cellar :any
    sha256 "ebae247d56b974509e45bc04c287d3d59e172b30282bc83999e2952bdfa3a7f2" => :mojave
    sha256 "892450c2dced041ea756b4eac28e9c82d353fe419226a9d5f0046ed56e00cbd7" => :high_sierra
    sha256 "635040b3eb071c077353d22495f61ee34013539be4272ea4e48a7a3a9ffb9f09" => :sierra
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build
  depends_on "protobuf@3.7"

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
