class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.124/+download/byobu_5.124.orig.tar.gz"
  sha256 "4eca1287b95093ac4697e6ebf7312308d54af90630db151669c5f328e0bef122"

  bottle do
    cellar :any_skip_relocation
    sha256 "427e22a1554e3a9236b2fc5769d3d69faac29b9f3664805fce0f434cdf85b63e" => :high_sierra
    sha256 "427e22a1554e3a9236b2fc5769d3d69faac29b9f3664805fce0f434cdf85b63e" => :sierra
    sha256 "427e22a1554e3a9236b2fc5769d3d69faac29b9f3664805fce0f434cdf85b63e" => :el_capitan
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

  def caveats; <<~EOS
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=#{HOMEBREW_PREFIX}
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
