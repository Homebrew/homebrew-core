class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  license "GPL-3.0"
  revision 11

  stable do
    url "https://mosh.org/mosh-1.3.2.tar.gz"
    sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"

    # Fix mojave build.
    patch do
      url "https://github.com/mobile-shell/mosh/commit/e5f8a826ef9ff5da4cfce3bb8151f9526ec19db0.patch?full_index=1"
      sha256 "022bf82de1179b2ceb7dc6ae7b922961dfacd52fbccc30472c527cb7c87c96f0"
    end
  end

  bottle do
    cellar :any
    sha256 "d864ba6a3869df2fd47894862f5f0b7d8e5f5f55daf58742243fa3ca8c69d474" => :catalina
    sha256 "1f46edf8fbd83303ea4156530357207b6ad538a6abbbd5118f9c39e4898a4a19" => :mojave
    sha256 "c8aa1ef313d62059bd8abee131880d5fa73f45e961388c055bc5f89970bcaf24" => :high_sierra
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", shallow: false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"

  def install
    ENV.cxx11

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
