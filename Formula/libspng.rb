class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.6.3.tar.gz"
  sha256 "381e4073221a8fbdb54b3022ac7ede6a62ec944dcf30599e4565ebb52b311dd8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6d41eb3e6c1938743b2214d4a18c7bb13a4908582380cf7583e7cfd74ab0f038"
    sha256 cellar: :any, big_sur:       "8cba8c9454c2d9892b39cd4b4dff9e32974f82ea5c220dc1e0aa90eb19406711"
    sha256 cellar: :any, catalina:      "9b5f9ce7f8e56210f9cce38d641517f5bf43dc5d9f45b75c6be9bc5ad76c1f1f"
    sha256 cellar: :any, mojave:        "8c2f036cc0b40a540d0aab26486f8f66b03b075fa78c7b39e912321115007bfd"
    sha256               x86_64_linux:  "1366686af344099f1a802870d56e7fdf86edb52beec4520f8deb2ed6b6cf7583"
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
