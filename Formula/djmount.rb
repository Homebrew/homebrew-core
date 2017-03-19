class Djmount < Formula
  desc "File system client for mounting network media servers"
  homepage "https://djmount.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/djmount/djmount/0.71/djmount-0.71.tar.gz"
  sha256 "aa5bb482af4cbd42695a7e396043d47b53d075ac2f6aa18a8f8e11383c030e4f"

  depends_on "pkg-config" => :build
  depends_on "libupnp"
  depends_on :osxfuse

  patch :p0 do
    url "https://raw.githubusercontent.com/DomT4/scripts/ee974414da/Homebrew_Resources/djmount/djmount.diff"
    sha256 "23d826748b63cf7b3b53e2b6f7e857ded9d8e0e8bcdf30095b3651fcfcb0eb41"
  end

  def install
    ENV["FUSE_CFLAGS"] = `pkg-config fuse --cflags`.chomp
    ENV["FUSE_LIBS"] = `pkg-config fuse --libs`.chomp

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-external-libupnp",
                          "--with-libupnp-prefix=#{HOMEBREW_PREFIX}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"djmount", "--version"
  end
end
