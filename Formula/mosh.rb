class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 8

  bottle do
    cellar :any
    sha256 "65aa6a28698ba757e7d87cd545626ea7ed5fe055653f0cf1720249799aa0981b" => :mojave
    sha256 "65cf515b56ae9f541b2b2cba50c3220d4258d2b3355d68104919dfcb86adeee1" => :high_sierra
    sha256 "1abc0a0d7ca0f1b55107cc91ae35e759dcbd2ed1eec7f8c14ecfe125c59d5de7" => :sierra
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
