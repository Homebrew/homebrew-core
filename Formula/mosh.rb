class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  license "GPL-3.0-or-later"
  revision 15

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
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "d1470fbc90fe39efa99654c554ec40643754249c7600d8e53d59d888ead3d9b8"
    sha256 cellar: :any, big_sur:       "ee9e5f52a4e9e19112f42427e1f869a318ee68f19aed1bbb29e3f0bae4f57406"
    sha256 cellar: :any, catalina:      "15efe4f981856e4df8da40350299730988a9c8b7d0fad98bf413d9e293e953a8"
    sha256 cellar: :any, mojave:        "f921eb384a179c6b65078a36bc479087c20de42562957d92510dc54dfec92c97"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", shallow: false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "protobuf"

  uses_from_macos "ncurses"
  uses_from_macos "openssl@1.1"
  uses_from_macos "zlib"

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
