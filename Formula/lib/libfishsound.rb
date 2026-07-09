class Libfishsound < Formula
  desc "Decode and encode audio data using the Xiph.org codecs"
  homepage "https://xiph.org/fishsound/"
  url "https://ftp.osuosl.org/pub/xiph/releases/libfishsound/libfishsound-1.0.1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/libfishsound/libfishsound-1.0.1.tar.gz"
  sha256 "03eb1601e2306adc88c776afdf212217c6547990d2d0f9ca544dad9a8a9dbb8f"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libfishsound/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libfishsound[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99677e9c5c6e576666daa65e86023c2c2172c338e9ea3a137b199b719cb21022"
    sha256 cellar: :any,                 arm64_sequoia: "316f6dd41ed7a843e382feacdaae02401cdf541c064f6802b95678aa1457a6d2"
    sha256 cellar: :any,                 arm64_sonoma:  "fde7d0521745d9a556999337b24fac1422d8f1c07302de7be5d892157dc88c5f"
    sha256 cellar: :any,                 arm64_ventura: "4fe1b44bee66fc57a820a3838cc0d38cf410b1f22a88c56dd996072edff460de"
    sha256 cellar: :any,                 sonoma:        "dc4573276c3c89484244b1ab2b121ab7d954d6e360c1a0e170dcaceb6d829e24"
    sha256 cellar: :any,                 ventura:       "a6ff774dad2e7d8bd2d46a33192b0aa1d53f6b34a6fbf49da9cc7a5d2718fd65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5706aa37fd98136ce0e3a9f3d3293d5483bb92e6f768163ffaef10267155d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfaa33c5d408f6f60308bc962a9815b0456de64c8f559c797589ab3f4118f4c3"
  end

  depends_on "pkgconf" => :build
  depends_on "libvorbis"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
