class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/refs/tags/3.4.1.tar.gz"
  sha256 "af9ec878f831b7c27d33e775c668ec79d569aa781861c995a0fbadc1bdb666cf"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b3a332a172d556f13fdd2ef8c5b993776785e64f40ac5618072c22ec4b18077"
    sha256 cellar: :any,                 arm64_sequoia: "275705af5f32669121f09010359ed54a913cd25c268cde4956753da6d3ed73c9"
    sha256 cellar: :any,                 arm64_sonoma:  "f8c77ed7920bc1a2b6bc2fa7eb578dfc12a061142bc29729f9cb66d3ac7c0234"
    sha256 cellar: :any,                 arm64_ventura: "c848a84e90f7882cee84f24fe5c6d77c38b8530eaef24ef09172fc54c1c81ca3"
    sha256 cellar: :any,                 sonoma:        "66f129d4a7275937877eb128b208a53879d8a7c518903522ff0a7318f84d9867"
    sha256 cellar: :any,                 ventura:       "e046c6078e2d30e54f2d0b10417b9b0e6de02aa31d889586cd1d3a5e87b8643c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f1eb1a8b344bda3f1f805743419260c0187ea3a05fdce7bb23708b085261a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b22b0ce29e0e73a86575daeaf0a01c6bb913f95d0b54172bba9021ec514fa7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
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
