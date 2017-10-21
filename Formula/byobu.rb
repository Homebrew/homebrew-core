class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.123/+download/byobu_5.123.orig.tar.gz"
  sha256 "2e5a5425368d2f74c0b8649ce88fc653420c248f6c7945b4b718f382adc5a67d"

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
