class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.4.tar.gz"
  sha256 "d8a0536ce95e3d59f8e292e73ee037033a74a8cc118fd10d22048bd4aeb61324"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "2a54d4c1b36e5c02f8ab9aab1252007b84e793cbed9dbc741e71a459b56213d5" => :big_sur
    sha256 "4daf7de742f59fb06e2b7352c00902f7f41397e8908aef3191ba502d9429a52f" => :arm64_big_sur
    sha256 "5e17b2dc3d695878ffb853ce707e7f813957b9e763b6b28efd71071335d74742" => :catalina
    sha256 "ecd4fef722e7a81727a489de6bed8f2ab37ee8009d98029d60029c11bc2eecbb" => :mojave
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
