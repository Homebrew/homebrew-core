class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.129/+download/byobu_5.129.orig.tar.gz"
  sha256 "e5135f20750c359b6371ee87cf2729c6038fbf3a6e66680e67f6a2125b07c2b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "a38947144d88d06d05ae8443d045d2c0e230f20f5de8ca617dd4436a73d74c91" => :mojave
    sha256 "072c0ed467ca88ca0f5f06a62e526f7e6a6891d52343a24a5bc2459c8227b739" => :high_sierra
    sha256 "072c0ed467ca88ca0f5f06a62e526f7e6a6891d52343a24a5bc2459c8227b739" => :sierra
    sha256 "072c0ed467ca88ca0f5f06a62e526f7e6a6891d52343a24a5bc2459c8227b739" => :el_capitan
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "newt"
  depends_on "tmux"

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
