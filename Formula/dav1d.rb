class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.4.0/dav1d-0.4.0.tar.bz2"
  sha256 "18bf96c5168b8c704422387620fefaa953e8dbd4eacb0f0796c03d6e741f8924"

  bottle do
    cellar :any
    sha256 "27deef5c5fb949caede94841ecb6f68c21f84f86a5251b3f5ea6b677abfaedab" => :mojave
    sha256 "af6fd10a3a742d96e099994bf9731505e569d4354d79d964bbe62b4125b6e932" => :high_sierra
    sha256 "00bc367af9e2af989a7106eb9cf710511ed5d9b9a95d29b4edf897decad7c96f" => :sierra
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
