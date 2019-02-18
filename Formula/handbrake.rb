class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.2.1/HandBrake-1.2.1-source.tar.bz2"
  sha256 "00316eec7bb29b88b8dd11b14581c99c35fd7a315f5bc8cc7f1eb144b2fa783d"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36f36b1bc2347424d14c7e94231fd8b03cc8fff86f1e0710547a59cbc3f70788" => :mojave
    sha256 "c3d9f1a25e8ae2becf69803614e426a13c8a5a99ed457cd4612b369636a8e460" => :high_sierra
    sha256 "e333be946a7c65ad707b9f26c4a9dab4a6a3cba0fc689f0cabd075cec1037f0c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
