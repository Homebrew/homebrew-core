class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.5.1/dav1d-0.5.1.tar.bz2"
  sha256 "0214d201a338e8418f805b68f9ad277e33d79c18594dee6eaf6dcd74db2674a9"

  bottle do
    cellar :any
    sha256 "0c445c0646f1680c5f9d7b14ed943a86f80c14593ac70555dac58cb914227e06" => :catalina
    sha256 "dcd2489d8c2d93218c577ea922dd991a4aa774d0d2f08fad18dcb0572a33eb0c" => :mojave
    sha256 "8b792db87b3202af2642ab9f3342af548b9db418ce4f21ced41fec3aa971511f" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/master/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", "--prefix=#{prefix}", "build", "--buildtype", "release"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
