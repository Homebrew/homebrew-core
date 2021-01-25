class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  license "GPL-3.0"
  revision 14

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
    sha256 "1bf08f5d050d35a8b8e12d8767e6cbd7cf8e42902773a07f0d77c33cdec80ecc" => :big_sur
    sha256 "f57678679b33783bc9eb6e163f1bdd52d3507610a95ab2adf3130b49b037da93" => :arm64_big_sur
    sha256 "bcd06e5e53910cdbe91f303791762bb48acf09a0b34e30510fd332a03d4170fe" => :catalina
    sha256 "e4686d0217150775f8d3f45707dc1a660714432b11b284a45946960fa34f2d6d" => :mojave
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", shallow: false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build
  depends_on "openssl@1.1"
  depends_on "protobuf"

  uses_from_macos "ncurses"
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
