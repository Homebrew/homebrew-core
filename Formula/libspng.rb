class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.7.0.tar.gz"
  sha256 "969fb8beda61a2f5089b6acc9f9547acb4acc45000b84f5dcf17a1504f782c55"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "39382406a73e80894d41a444e05b9b91887f57fce69ee25e2f8ff1bda7999ffc"
    sha256 cellar: :any, arm64_big_sur:  "191f00d597872763bdd69aee6b28f01d07e0cdd4216d7841589351cd79b4e33a"
    sha256 cellar: :any, monterey:       "01ddffe0776ff5f8ca781cf1f596726d0ff97f43edd7048e351dc3eabe711f95"
    sha256 cellar: :any, big_sur:        "20343c6622470a53ed19ee893f48e1a1a9c529426204b5b1869e590ce83767c3"
    sha256 cellar: :any, catalina:       "ddbcbef115498ac21c7ac10006c8d7de824103413754493edf051ab8c13492d1"
    sha256 cellar: :any, mojave:         "f319bda14642b057ee35abc95ed58bc8529c0028761f8989bdcefb0adf7488b0"
    sha256               x86_64_linux:   "5f3451f468d58685c26c80f33980d7195f0411d3f4bab347704ca02bf42390b2"
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
