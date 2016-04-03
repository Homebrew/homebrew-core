class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.0.1/htop-2.0.1.tar.gz"
  sha256 "f410626dfaf6b70fdf73cd7bb33cae768869707028d847fed94a978e974f5666"
  revision 1

  bottle do
    sha256 "b8afe978bc97ef2d18767c769941b81e0501c20566d2427e2e421bb69ca94e5a" => :el_capitan
    sha256 "f667485b77c96a1c7fe4923858cb60f1d5700412a1921dd9a12ac4fb50f305f2" => :yosemite
    sha256 "47fd6612ee8889637c3aa47a6c8cdc5812b8b8f8fa4853f35f2131bb8da43884" => :mavericks
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)"

  depends_on "homebrew/dupes/ncurses" => :optional

  conflicts_with "htop-osx", :because => "both install an `htop` binary"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    htop requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/htop", "q", 0)
  end
end
