class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.121/+download/byobu_5.121.orig.tar.gz"
  sha256 "5df2415f93ec8c78d1402c091664372f2164ca8739bf509a42853800e7597c65"

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
