class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "47ec02be6c0a6323044600a9221b049f63e1953faf816903e7383d4dc4234487"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b7021367db7d381734cae9e0f63d0306a59ebb9cf2483550882e1c944ffd28ba"
    sha256 cellar: :any, arm64_sequoia: "30ec0f19c1307c939d1be6320da640bce932768da9cc01adb079de69c2e64871"
    sha256 cellar: :any, arm64_sonoma:  "1760a7efb11ab271254958b8c112c1017066f5dc8054354a99e0fdae26989a0e"
    sha256 cellar: :any, sonoma:        "9ebab1a353c99351786e0df0921ddd3fc9ace5394853223a7ce1e8e2efd333c0"
    sha256               arm64_linux:   "beb537b513a5934a9d7a7b45dd73f3a46e4e79ab690b30276fa6e94fea1b0d73"
    sha256               x86_64_linux:  "1cf4918ffa2127b4ce1a8be69c8710902489fdfed0418acf8b02210a549bba3e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

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
