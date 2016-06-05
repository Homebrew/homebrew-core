class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co"
  url "https://launchpad.net/byobu/trunk/5.108/+download/byobu_5.108.orig.tar.gz"
  sha256 "a8ad1e99b32dbafcd1cb6a58b6541ea177850567d504218af08ffac79a01e39e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7234c1e2b6101aaf00ea954d8a43d98329bb4eaa389341be1ab0fa3981a13b6a" => :el_capitan
    sha256 "e681c3cf02637ece66cef01633d9e4fe94134f8504972786a9f6227f9d631f14" => :yosemite
    sha256 "d670086050d0a02e2d313f1cbcb1ee1042bc571ca212d2b0966282814d1f360a" => :mavericks
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt" => "with-python"

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
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
