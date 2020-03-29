class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 10

  bottle do
    cellar :any
    sha256 "1f77a276cbba48a41505658a146853a01fd49e68f5ed39592e95f4b982860fa6" => :catalina
    sha256 "5489299d991ac0ede82de439b94e6148fc6620b60ab795d8da21c976f09ed6eb" => :mojave
    sha256 "9994025f67ff132e87310f596539af84f57ba53ce05b71fd9d0bd6069c681e84" => :high_sierra
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"

  # Fix mojave build.
  unless build.head?
    patch do
      url "https://github.com/mobile-shell/mosh/commit/e5f8a826ef9ff5da4cfce3bb8151f9526ec19db0.patch?full_index=1"
      sha256 "022bf82de1179b2ceb7dc6ae7b922961dfacd52fbccc30472c527cb7c87c96f0"
    end
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
