class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.7.3.tar.gz"
  sha256 "a50cadbe808ffda1a7fab17d145f52a23b163f34b3eb3696c7ecb5a52340fc1d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "deb3a3d4552e7c993cb6f91645f52488ba1e7c310c60f07544e16b2918ff7575"
    sha256 cellar: :any,                 arm64_monterey: "84b61c16e0cf8ec194780d6616eb3670c26369d0b79f4670c63a5583b646c223"
    sha256 cellar: :any,                 arm64_big_sur:  "a152fb7f0a64b0ddac056e29578c6cebb64dae60cba7509ed4f82f3c59ac1591"
    sha256 cellar: :any,                 ventura:        "d8784bef29e67699a913680022e5a48d6f499bf19564228383efdfbb9a518c8a"
    sha256 cellar: :any,                 monterey:       "c3190740fd003e35cbeb8b71c0cae74bbc49478a5581781289bcd6a3966afaee"
    sha256 cellar: :any,                 big_sur:        "fa2c6820fcdfe82921c55d077c696210bfcf7185e84a384fd8a14779117e212f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8590ea4e1f4679adf589ceef9ad5a39b32aa24678d75cd6194d8b1114ef2747"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    pkgshare.install "examples/example.c"
  end

  test do
    fixture = test_fixtures("test.png")
    cp pkgshare/"example.c", testpath/"example.c"
    system ENV.cc, "example.c", "-L#{lib}", "-I#{include}", "-lspng", "-o", "example"

    output = shell_output("./example #{fixture}")
    assert_match "width: 8\nheight: 8\nbit depth: 1\ncolor type: 3 - indexed color\n" \
                 "compression method: 0\nfilter method: 0\ninterlace method: 0", output
  end
end
