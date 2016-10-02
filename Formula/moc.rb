class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net"
  url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.1.tar.bz2"
  sha256 "1b419c75a92a85ff4ee7670c65d660c86fef32032c65e89e868b988f80fac4f2"
  head "svn://daper.net/moc/trunk"

  bottle do
    sha256 "6a61f09a91ff078af9cc894163e3e4a46c38c2e65cd0cb51a4f0e2d8462e09fa" => :sierra
    sha256 "07858cac0bd2b7e6082ee7d3806f245f4278135cfb3f9af5513f5f20bc1f6a0e" => :el_capitan
    sha256 "07cdc844dc3b059dd9c4e61718a6d3379ef081e1548c4dcd3f97e414bd0f277b" => :yosemite
    sha256 "3aacade3cb44173bfa290ee9e58f591e0e29a89b77c0257cdf8e1643a424c51e" => :mavericks
  end

  devel do
    url "http://ftp.daper.net/pub/soft/moc/unstable/moc-2.6-alpha2.tar.xz"
    version "2.6-alpha2"
    sha256 "0a3a4fb11227ec58025f7177a3212aca9c9955226a2983939e8db662af13434b"

    depends_on "popt"
  end

  option "with-ncurses", "Build with wide character support."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
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
    system "autoreconf", "-fvi"
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
