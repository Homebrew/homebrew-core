class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.2.1.tar.gz"
  sha256 "b5ffac1949a8daaabcffa659c0964360b5008782aae4dfa7702d2323cfb4f438"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "50735eb9e09ec8087f04640430d4bdac4941a0ce584dd1e52ec8ec8a58d743ed"
    sha256 cellar: :any,                 arm64_big_sur:  "02e592c85dbfe7ee6bb0a2bf5275cc6434710aaa30d7756d11a363946a5cb76e"
    sha256 cellar: :any,                 monterey:       "13ede571c82f9ed6f55d8ef081bd7db0f11ca8945dc306594465384f38f693f4"
    sha256 cellar: :any,                 big_sur:        "3004679265a03a1d4d5162895e79de630535a7d6ebe0c59592cb307ed9aeb5d5"
    sha256 cellar: :any,                 catalina:       "6a0040374a95b5adf832d15b69ee80fbe3fc24190f523f46e199e0cb60fd9057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "864f057daa4b3361cf076523e9a532763153a512cbd7da90bfb6b10ecfca0c05"
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
