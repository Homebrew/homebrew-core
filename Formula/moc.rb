class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net"
  url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
  sha256 "f3a68115602a4788b7cfa9bbe9397a9d5e24c68cb61a57695d1c2c3ecf49db08"

  bottle do
    sha256 "c6441a6396a213644e39dae1bf920a7b773bb7c4730bfd1e751dd480d0bb80a0" => :sierra
    sha256 "db6e67d930ebfb2c414c834f67a8a228bf0300d8025df34fd57dccc5ffd84bd3" => :el_capitan
    sha256 "2ad36030c2731d46aa672e927a957843cbbbefcb1bc51fdb91c973e1e3a18a66" => :yosemite
  end

  devel do
    url "http://ftp.daper.net/pub/soft/moc/unstable/moc-2.6-alpha2.tar.xz"
    sha256 "0a3a4fb11227ec58025f7177a3212aca9c9955226a2983939e8db662af13434b"

    depends_on "popt"
  end

  head do
    url "svn://daper.net/moc/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "popt"
  end

  option "with-ncurses", "Build with wide character support."

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "berkeley-db"
  depends_on "jack"
  depends_on "ffmpeg" => :recommended
  depends_on "mad" => :optional
  depends_on "flac" => :optional
  depends_on "speex" => :optional
  depends_on "musepack" => :optional
  depends_on "libsndfile" => :optional
  depends_on "wavpack" => :optional
  depends_on "faad2" => :optional
  depends_on "timidity" => :optional
  depends_on "libmagic" => :optional
  depends_on "homebrew/dupes/ncurses" => :optional

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
        You must start the jack daemon prior to running mocp.
        If you need wide-character support in the player, for example
        with Chinese characters, you can install using
            --with-ncurses
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mocp --version")
  end
end
