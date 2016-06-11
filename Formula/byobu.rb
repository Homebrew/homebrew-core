class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co"
  url "https://launchpad.net/byobu/trunk/5.108/+download/byobu_5.108.orig.tar.gz"
  sha256 "a8ad1e99b32dbafcd1cb6a58b6541ea177850567d504218af08ffac79a01e39e"

  bottle do
    cellar :any_skip_relocation
    sha256 "adaaa0950a8233b6dd62ec9636941767e73a4232890e5ce0ce6c70fac3a7898c" => :el_capitan
    sha256 "4978224763c5c36224bc4f48f99be02b8d3f0e13b3e91adfd2c50ca7db169b59" => :yosemite
    sha256 "d864896fa727c88277960bc64ba64c2d97598ab477320cd3eceb751f393f5380" => :mavericks
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
