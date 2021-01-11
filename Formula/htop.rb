class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.5.tar.gz"
  sha256 "4c2629bd50895bd24082ba2f81f8c972348aa2298cc6edc6a21a7fa18b73990c"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "5b426171d65d806dd20cb54ebc86bba7f3f3093242de8a3a88492a90f07c14c7" => :big_sur
    sha256 "57b9e6f3528fa3ffa0b1bfb64c18c42e4bc2cd8dfdb20d0373b97fe1dc805016" => :arm64_big_sur
    sha256 "f2d386785f45508a062701ce936e316daf8c312d73da02cb3c58ef79393e3a53" => :catalina
    sha256 "94975a5e046d3a4ee564c7a8d75355f91138f818e6782dcc8ca07e08fb18bf8e" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "ncurses" # enables mouse scroll

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
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
