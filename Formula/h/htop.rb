class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/refs/tags/3.5.1.tar.gz"
  sha256 "dfc4a09845e9bc86f466a722e62b8f87d59028ff39689077ff2257a6a605061d"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db7f9d7446c4bdfbf056f8ec72eb6a0e980fc02fc1dfd8a2276fa2850b8e8e01"
    sha256 cellar: :any,                 arm64_sequoia: "1b113c54d858a69b96802f5673f59e888fcb1ed16453658145090e8c4f99e4ea"
    sha256 cellar: :any,                 arm64_sonoma:  "1d6d45bae52d39a2f19cecfa43b6e4cecc9c1a9895f30795c7e74c790348efd9"
    sha256 cellar: :any,                 sonoma:        "6201b1181a3160778504ad76a3e641a8754027ce517924bc3c2a142046d0354d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578b86f2ca817ee887c756f7d1a994b522240431900164cf9dbe1d7dbb1aaa93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c3b2a8655007ecc5cbdcc440d96294e6175ba8760bf28548fb7e5ec30b19edc"
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
