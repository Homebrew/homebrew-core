class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/refs/tags/3.3.0.tar.gz"
  sha256 "1e5cc328eee2bd1acff89f860e3179ea24b85df3ac483433f92a29977b14b045"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "3ef4d2047472d6f8fff23cc60e4171fb5cb1ad6a546f0b54e97b43e8d5f97053"
    sha256 cellar: :any,                 arm64_sonoma:   "ea457e022296c96a73ebecc31119ea225c2b41670426a9099bccf5f1d17673ec"
    sha256 cellar: :any,                 arm64_ventura:  "5895685e6db67598024850ca3c440e1244ee5dd54bc7c6b5345b28d74f9fa4f0"
    sha256 cellar: :any,                 arm64_monterey: "91b0b5fe4ffb977e6381664d74ec48e890da908a346473b5e4d88f8117a2dc23"
    sha256 cellar: :any,                 sonoma:         "c3ee757e215de2dfd151ea9eb68ef53bb64ba86c5d07a443c6477bdb952f02bf"
    sha256 cellar: :any,                 ventura:        "69f690190833cf309baa396b7a7a8218ec012ca93e0825a2b2a4d9f0d5cafb33"
    sha256 cellar: :any,                 monterey:       "9872ffeea0cbab0d5f2e418fd06442663a113b67be12e15b0ece20e701f4ada3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ee4a9f06bc81442fc93e02f8aa875a7641781aa147aab1f863e5c4d744b47d"
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
    pipe_output(bin/"htop", "q", 0)
  end
end
