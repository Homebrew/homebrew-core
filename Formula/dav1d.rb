class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.9.2/dav1d-0.9.2.tar.bz2"
  sha256 "0d198c4fe63fe7f0395b1b17de75b21c8c4508cd3204996229355759efa30ef8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "990495bbaf3c78c8de9e21916f8d0ddbcb1ecac54af154d363679ce93d6cc668"
    sha256 cellar: :any,                 arm64_big_sur:  "d03b6fb80959882f28f578b0cadb330a3ebbedd511ed47315990f733c9dd5db4"
    sha256 cellar: :any,                 monterey:       "77ac78e014a58ba42c630f48ed7bd9a6919d8693cf901b9eeff999603d897be4"
    sha256 cellar: :any,                 big_sur:        "32baa0d1898c4640842e29e743fd7ce4a9bc7c5c3e8937086b1eed267d20c938"
    sha256 cellar: :any,                 catalina:       "6bbb978d3c3b20a7b2df2b27e1a41cbd60a81fe4baa248f128de98133a400576"
    sha256 cellar: :any,                 mojave:         "88b9800aa5a7263d58e690aaf39e51a759f71dd84da49138c9aba23bff80d3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fcc7b43ce7dbeebb86ebd2e90f5669bc748ce5138d5fcb8452aae9b606a3cb4"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/0.8.2/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", *std_meson_args, "build"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
