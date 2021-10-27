class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.1.1.tar.gz"
  sha256 "b52280ad05a535ec632fbcd47e8e2c40a9376a9ddbd7caa00b38b9d6bb87ced6"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a750757241fe07c332f12157fefd3122d223ad1356e1a85e70c78e8ab69aebc2"
    sha256 cellar: :any,                 arm64_big_sur:  "bc5dfcfd0b154377c4436bc3f2c35a43d618319c43e9184d13832e06fdd79820"
    sha256 cellar: :any,                 monterey:       "2467211375028b6d784c35b1d396971177023518e49566f160a4aa5b8dfdc470"
    sha256 cellar: :any,                 big_sur:        "301c8306cbfe6584335a8e7db71e2436e336357b0371f5cf29b94b1a557c6652"
    sha256 cellar: :any,                 catalina:       "7ddeb74a5a6873b69f705fb090e6b477dec8261dbb221a5b8dbc6bcc810af804"
    sha256 cellar: :any,                 mojave:         "c5a1729400dfec62ee63ab53e5667f06d4709ee9021e3573c8ec1fd6ae4fcebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33628783ecc09a777afce0eb819e877a9379e71f9f22a074316ebf7ef2f47f4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
