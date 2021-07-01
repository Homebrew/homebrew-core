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
    sha256 cellar: :any, arm64_big_sur: "e2b32da2189775e5a303b948bf2bf86224f2850786e849371efe002402f26c6f"
    sha256 cellar: :any, big_sur:       "8f4e4c5d0ee34c41e008bb9a2ed4331303a42bd594ac358a822604a145c868ea"
    sha256 cellar: :any, catalina:      "7dc2bf8825918876e3a853acbc9d7045786d1d418fdae2b0a4e6d4500006a08e"
    sha256 cellar: :any, mojave:        "a009b141dcf7b95c60da3ef685ea0736be0c0a5e1e0de0945153697c6a032e2a"
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
    on_linux { args << "--enable-sensors" }
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
