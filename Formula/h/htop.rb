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
    sha256 cellar: :any,                 arm64_sonoma:   "a07989af65c77dbfb28b07b8faec12d3760831c360e0caa6a32a58eff0e8fd65"
    sha256 cellar: :any,                 arm64_ventura:  "66603fe2d93294af948155b0392e6631faec086b0bcc68537d931861e9b1de39"
    sha256 cellar: :any,                 arm64_monterey: "f8c4b4433a3fda0ee127ba558b4f7a53dff1e92ff6fb6cef3c8fbf376f1512c8"
    sha256 cellar: :any,                 sonoma:         "5cd79199db8d7394d331dbb362dd101d12519325f78dde1af4e7c67fb9f4e5da"
    sha256 cellar: :any,                 ventura:        "d47397e29f584bedd7d1f453af5ff42f10c3607a823fa72314b6d4f1c44cd176"
    sha256 cellar: :any,                 monterey:       "665c48cbe7434b5850d66512008e143193cd22b69ae54788314955415b6c546d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6734208d3ea8db55123b1d1d9ac4f427c5e7ba89472193afe51543a2bb1a9a1"
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
