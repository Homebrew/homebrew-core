class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.1.tar.gz"
  sha256 "b47fcd70fc63b6c72dd4a27ba173d0ca199102c00fe292736d71f44bd4223184"

  bottle do
    cellar :any
    sha256 "bfc478e1a13f48bec26016b9dca00d912a4df9dd60e1a80779c063f76e507e50" => :mojave
    sha256 "f50a091ab3c3e15e104093b02eb8278f54f9feecb49424cda90c011b0d942b94" => :high_sierra
    sha256 "53cba0d94703c47503e276b7116a77d45c6a1a51976d97bcfb12ae8722a473b5" => :sierra
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
