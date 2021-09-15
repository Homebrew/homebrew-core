class Curlftpfs < Formula
  desc "Filesystem for accessing FTP hosts based on FUSE and libcurl"
  homepage "https://curlftpfs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz"
  sha256 "4eb44739c7078ba0edde177bdd266c4cfb7c621075f47f64c85a06b12b3c6958"
  revision 1
  head ":pserver:anonymous:@curlftpfs.cvs.sourceforge.net:/cvsroot/curlftpfs", using: :cvs

  bottle do
    sha256 cellar: :any, catalina:    "2d3fea0aecd1856a956cedcf8ab992f217bd730371c6eb80900158c69f138aa8"
    sha256 cellar: :any, mojave:      "b4f74999789cdb534784428530110421a256adc2b276ed8f372c8498e31719a0"
    sha256 cellar: :any, high_sierra: "edb3da0b0ccc3b5b3004096f89174786ad75838b82b6c6b621855291744147f1"
    sha256 cellar: :any, sierra:      "5734dbff6e2a7c18232d08d22fe64e19610f32b07e48b276996df759baaef407"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  # TODO: depend on specific X11 formulae instead

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV.append "CPPFLAGS", "-D__off_t=off_t"
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end
end
