class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.5.tar.gz"
  sha256 "4c2629bd50895bd24082ba2f81f8c972348aa2298cc6edc6a21a7fa18b73990c"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "4dd5d67e6a0ce026916e082e834a9a3e8e8e01c4ac3a79a3de29119dd6cc8393"
    sha256 cellar: :any,                 big_sur:       "21f7d036b92a40bb57dc28c64249f137efcbec7489190944d8c38f940c86df9f"
    sha256 cellar: :any,                 catalina:      "0b9cb4738ad23eed5e2d24bb2bdc10e662c3b54ba7feb22d798fd9107ace5e21"
    sha256 cellar: :any,                 mojave:        "7be858d053b14ab834cd1a1832beaf367501639d17c7a43c5cc0e563c025a4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ecd7b41016d7c5deadd4255982b654c05bf46cc97792dbe38a0f71ff17d477"
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
