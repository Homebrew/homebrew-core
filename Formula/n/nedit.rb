class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.7-src.tar.gz"
  sha256 "add9ac79ff973528ad36c86858238bac4f59896c27dbf285cbe6a4d425fca17a"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "63e38eb761dcd2a048f2cb5dcb614fcfb7c5e89b66883316628c95eeec52e35d"
    sha256 cellar: :any,                 arm64_sequoia:  "a4e7775080f68b28a71f10c696a4a57c347d4f6620dde7e033bb3c5083db4250"
    sha256 cellar: :any,                 arm64_sonoma:   "8f6e94981bc35788dba9284a2313b48003f8a6bb10b26f15ee4dc2f20c4ecba5"
    sha256 cellar: :any,                 arm64_ventura:  "2ce67e319d75468e209d20d306cb6c3dcacea83feafd8114902273b1cb4b3344"
    sha256 cellar: :any,                 arm64_monterey: "9ee06ab3c8df64e26b87d80ac63acfff12ce97286ce115f2fc8882b3e4c88605"
    sha256 cellar: :any,                 arm64_big_sur:  "e81454f55e5a3b396abe741f65a4a2600d18e93301385edd3481d8d55cee20c0"
    sha256 cellar: :any,                 sonoma:         "8422e83c7f1428b1188a85db7c86ede8660169ebe97c14728a45a7428908d7a7"
    sha256 cellar: :any,                 ventura:        "4a0ede3b87a97df3bb77ef2ffaac6632cb6f3834c1208cf9c076c0b3eda751c4"
    sha256 cellar: :any,                 monterey:       "97501b6d060c2da91ce81ff637fc9898e5f3696c0ca6005ea862d5cf3b9b59f6"
    sha256 cellar: :any,                 big_sur:        "d39ce752a03c79732c908a3cbe93df61f413a12126f764e7e1c3d71f4106f701"
    sha256 cellar: :any,                 catalina:       "c726811764a5d12465d4c11b273229482af935921df472f6d083a27e34b39b3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55378caed6582cb7f9dc529539d45ec7195c4ef042eca0d152d76663c60af47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd75a55df6025af2525c13fb2657d74632fac30c2d813eda1d07ae1eea146ffa"
  end

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  uses_from_macos "bison" => :build

  def install
    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    system "make", os, "MOTIFLINK='-lXm'"
    system "make", "-C", "doc", "man", "doc"

    bin.install "source/nedit"
    bin.install "source/nc" => "ncl"

    man1.install "doc/nedit.man" => "nedit.1x"
    man1.install "doc/nc.man" => "ncl.1x"
    (etc/"X11/app-defaults").install "doc/NEdit.ad" => "NEdit"
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/nedit 2>&1", 1)
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/ncl 2>&1", 1)
  end
end
