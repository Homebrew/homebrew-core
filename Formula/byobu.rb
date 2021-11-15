class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://launchpad.net/byobu"
  url "https://launchpad.net/byobu/trunk/5.133/+download/byobu_5.133.orig.tar.gz"
  sha256 "4d8ea48f8c059e56f7174df89b04a08c32286bae5a21562c5c6f61be6dab7563"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4b6177bef58c89b06a356a0bb96aae9cf60678442af57f9a5e7489b3a162ae6"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3b41a0d0546732f6bbbdedae5357df00625f5c9f7be0b631c4a0778107d3549"
    sha256 cellar: :any_skip_relocation, catalina:      "39b468dabc1497338b4511f9f565f9adcdd058a99207de345da28b18a0826ae6"
    sha256 cellar: :any_skip_relocation, mojave:        "39b468dabc1497338b4511f9f565f9adcdd058a99207de345da28b18a0826ae6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "39b468dabc1497338b4511f9f565f9adcdd058a99207de345da28b18a0826ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f84ea55ef2950c34c48f77609c4d00d9a35bd5ca13140aa98b8175ea1a04cf2f"
    sha256 cellar: :any_skip_relocation, all:           "f84ea55ef2950c34c48f77609c4d00d9a35bd5ca13140aa98b8175ea1a04cf2f"
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

  conflicts_with "ctail", because: "both install `ctail` binaries"

  def install
    if build.head?
      cp "./debian/changelog", "./ChangeLog"
      system "autoreconf", "-fvi"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following to your shell configuration file:
        export BYOBU_PREFIX=#{HOMEBREW_PREFIX}
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
