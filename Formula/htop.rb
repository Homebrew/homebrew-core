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
    sha256 cellar: :any,                 arm64_monterey: "45c0f1c73aedf0ea6ab4d3a52d892c514c707308502fc93b55ecdde191ba350d"
    sha256 cellar: :any,                 arm64_big_sur:  "01cece6f30de91f3cb9a67fbd0f04a79ca07ced3f798bb9e43a1d49dcfb151d8"
    sha256 cellar: :any,                 monterey:       "77e0033be74275bd295b7cb3fab804d0868cc19bf3e228f754e13efbaa03d46d"
    sha256 cellar: :any,                 big_sur:        "af65b75242c8b5e6e4f1fb0d16674f58a574abd4c81a9351b9d38a20d8a756d0"
    sha256 cellar: :any,                 catalina:       "cf18273f26be8596422deed0c19c050ce9f472bdb5b63f47d34f8a0333ece4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c0d9be63b85744846a23f50e56a4909c626e6929dadda6a861fc5291994027"
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
