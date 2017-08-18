class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.122/+download/byobu_5.122.orig.tar.gz"
  sha256 "0e5f14db8340712cf5b1049002c5b7f2a116ca28e6df418cb7500d3c4fa43234"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac7e357af588af7fbb00539f807cb25c2753f4c76aa9ddbfeba5240132f47f3d" => :sierra
    sha256 "ac7e357af588af7fbb00539f807cb25c2753f4c76aa9ddbfeba5240132f47f3d" => :el_capitan
    sha256 "ac7e357af588af7fbb00539f807cb25c2753f4c76aa9ddbfeba5240132f47f3d" => :yosemite
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
