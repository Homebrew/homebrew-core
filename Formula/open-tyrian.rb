class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://bitbucket.org/opentyrian/opentyrian"
  url "https://www.camanis.net/opentyrian/releases/opentyrian-2.1.20130907-src.tar.gz"
  sha256 "f54b6b3cedcefa187c9f605d6164aae29ec46a731a6df30d351af4c008dee45f"
  head "https://bitbucket.org/opentyrian/opentyrian", :using => :hg

  bottle do
    sha256 "2b3baee271c7575088df18c5172ef15ee9f7a38e87adffeb2769aad70bce0b6d" => :mojave
    sha256 "d6e606749fa4e1a9d1fea42ede8d2a195677f112c20f3c23cd3b0bb86988b84f" => :high_sierra
    sha256 "4f55db177b78370597bc596797cfb9f08c3a7249ce3e53130fc349d4b4fdb6d5" => :sierra
    sha256 "90612b1c31262d8e0ae681842197370d278b51fdb46cce6a0a40e2595a4c831a" => :el_capitan
    sha256 "6c3ebd2d00d744211373e8457a3df645a5d402e521b40f7c46139cc9e4c33dc6" => :yosemite
  end

  depends_on "sdl"
  depends_on "sdl_net"

  resource "data" do
    url "https://camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("data")
    args = []
    if build.head?
      args << "TYRIAN_DIR=#{datadir}"
    else
      inreplace "src/file.c", "/usr/share/opentyrian/data", datadir
    end
    system "make", *args
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system "#{bin}/opentyrian", "--help"
  end
end
