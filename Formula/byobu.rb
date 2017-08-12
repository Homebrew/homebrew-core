class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.121/+download/byobu_5.121.orig.tar.gz"
  sha256 "5df2415f93ec8c78d1402c091664372f2164ca8739bf509a42853800e7597c65"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3c80cc2e173aaf6a1c735e2d3427a00e19e953409fc6579503dae04eee48a05" => :sierra
    sha256 "d3c80cc2e173aaf6a1c735e2d3427a00e19e953409fc6579503dae04eee48a05" => :el_capitan
    sha256 "d3c80cc2e173aaf6a1c735e2d3427a00e19e953409fc6579503dae04eee48a05" => :yosemite
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
