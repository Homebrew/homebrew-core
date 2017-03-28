class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.116/+download/byobu_5.116.orig.tar.gz"
  sha256 "85251e149bc56cfeb299c88b32390889b73b444f47039f9206a012602ecb9748"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e0cf31b24ac96edafe8cb09abecb84a556adb64f103acbb5585a5d090a0f1c9" => :sierra
    sha256 "9e0cf31b24ac96edafe8cb09abecb84a556adb64f103acbb5585a5d090a0f1c9" => :el_capitan
    sha256 "9e0cf31b24ac96edafe8cb09abecb84a556adb64f103acbb5585a5d090a0f1c9" => :yosemite
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt"

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  def install
    if build.head?
      cp "./debian/changelog", "./ChangeLog"
      system "autoreconf", "-fvi"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=#{HOMEBREW_PREFIX}
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
