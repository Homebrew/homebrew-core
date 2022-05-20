class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.2.0.tar.gz"
  sha256 "1a1dd174cc828521fe5fd0e052cff8c30aa50809cf80d3ce3a481c37d476ac54"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "160f154f147eb9895626ac2a6aa9aaf16d561828067c1faa7e990e7e50a0efde"
    sha256 cellar: :any,                 arm64_big_sur:  "0b5b52d11c885e8661a69e342d0778c5c71ecd57bc5c366fa28911967b2d1191"
    sha256 cellar: :any,                 monterey:       "eac8d539403c7b3c1dee9e16454399e9963191c79a7b5cda343bb4b13cdf7f61"
    sha256 cellar: :any,                 big_sur:        "e4b21db63251f1c3472e5c76372451017ed008a21afce273d0633bd8acb3de7d"
    sha256 cellar: :any,                 catalina:       "998bbe3612d1d5da046351e28037c68fc894d2847fd08648b3fcce26141cf098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ed8c32a717de42eec088976dbe561b5904fc11753f6b1c376f36a34af057802"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses" # enables mouse scroll

  on_linux do
    depends_on "lm-sensors"
  end

  def install
    system "./autogen.sh"
    args = ["--prefix=#{prefix}"]
    args << "--enable-sensors" if OS.linux?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
