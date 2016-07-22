class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz"
  sha256 "179be9dccb80cee0c5e1a1f58c8f72ce7b2328ede30fb71dcdf336539be2f487"

  bottle do
    sha256 "17e7e101576e5a6ab21c9cb466abb06c9aa9f41bf48a8bafab7b35724be10a22" => :el_capitan
    sha256 "ae6da1461494e36c71e5ccf77f3b84d89b83eb5edc50b25e170c6021de8d3978" => :yosemite
    sha256 "0105446a79d2a2d8e559f1e815597dc735efe50cf51d9de27c545f0a1a881d1f" => :mavericks
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
