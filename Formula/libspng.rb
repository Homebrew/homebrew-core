class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.7.1.tar.gz"
  sha256 "0726a4914ad7155028f3baa94027244d439cd2a2fbe8daf780c2150c4c951d8e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "113f103b85fb26b23deea38dba6952e43eb5f66a7b487435bb6192cc226afdd8"
    sha256 cellar: :any, arm64_big_sur:  "3dab6addd815f5c2581819f6898a5b89697749e6430bec257070427e16b0ab48"
    sha256 cellar: :any, monterey:       "f3ad98cd2b7c1cfc01016b7971b02d35d3a96625e2846b52a4b08c0f8429b49b"
    sha256 cellar: :any, big_sur:        "348a4922588fdaac780287189ac57df2e0f8161eb52c433279fff1c91c83fd79"
    sha256 cellar: :any, catalina:       "2b901c432dee3e6cc812445d71801fd4454cd1c1950214bf4654a97de358fdc6"
    sha256               x86_64_linux:   "3512ae373da63acb54044f904e61e00a3a674e2b4d30153498f65bbda91a8c78"
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
