class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.2.2.tar.gz"
  sha256 "3829c742a835a0426db41bb039d1b976420c21ec65e93b35cd9bfd2d57f44ac8"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa11348878695cc969b76354c14d8f8ff60554ffa89cb71a3a258b88e222a1af"
    sha256 cellar: :any,                 arm64_ventura:  "87daed2cfe0d478a778b09b5f29428f05b15ff081f0e70b9a2609cf479572721"
    sha256 cellar: :any,                 arm64_monterey: "76872761874d2148c1da382b3922b25916f245ef1d05fa21f95dbc1baa5ff8d4"
    sha256 cellar: :any,                 arm64_big_sur:  "52bdaef69f06d6808896cd8325ff6b2be3f96643660cc5475e1d45ba850a594d"
    sha256 cellar: :any,                 sonoma:         "38726954cd1d7141bc5cbfd8893bf4bdb6ae34b87959453eb4a31a466d672c00"
    sha256 cellar: :any,                 ventura:        "38dcedb23adca849a1e1952c4a0d3249406b625f0e2094dfc47028be7df304b2"
    sha256 cellar: :any,                 monterey:       "078c94ade63f91b01334d300f00489592361bdfef3600c0ca7f6ad3ce2032281"
    sha256 cellar: :any,                 big_sur:        "7620c57b8abc846f264fb7906b96f3da07da7c6d2b43bde1579c29e04c77fc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb45255abf5f0cd1d886bb8ea68b26c60517771268cf18ac3cec875b572b1fc6"
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
