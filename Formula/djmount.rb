class Djmount < Formula
  desc "File system client for mounting network media servers"
  homepage "https://djmount.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/djmount/djmount/0.71/djmount-0.71.tar.gz"
  sha256 "aa5bb482af4cbd42695a7e396043d47b53d075ac2f6aa18a8f8e11383c030e4f"

  bottle do
    cellar :any
    sha256 "d2ac3aa0c76c1489d7addcb9d9d4a9cb850f3dd9db3bc939ba6bc97e38668e4f" => :mojave
    sha256 "4d70d21ce227a8a1e84df11152a0f587d647b21df8585fe69e54a133a9299795" => :high_sierra
    sha256 "47be8c859fd5271a518ed61bf2a70c1baea0314e5ad10fefbe0d43fc5a8bd99a" => :sierra
    sha256 "b5a178484c96047baadd5717bd5ba0cbf6b2f00fe2e6a21095dd02f45668c61d" => :el_capitan
    sha256 "774dae46551c0a92244f01816d747a0c0e52d5898fe93792d3e9e3267845acbd" => :yosemite
  end

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
