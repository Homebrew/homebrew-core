class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.7.2.tar.gz"
  sha256 "4acf25571d31f540d0b7ee004f5461d68158e0a13182505376805da99f4ccc4e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3abf9e800bffec5d364bc8f1aa827e94b796746638ddcc08ba2c3018db50c41b"
    sha256 cellar: :any, arm64_monterey: "beee48ecc0e830637aa96f467641e2659a6376f3e34e07d2af6d920f1a84e79d"
    sha256 cellar: :any, arm64_big_sur:  "e47bb6a47f616846ae372120b4dd020f199472a4d0fe1ff2c3b9baa9ac3702fb"
    sha256 cellar: :any, ventura:        "dc7805748b90b4d0df7aad7cf82f3ae3215a5999660c1c3e6564a509ee729d44"
    sha256 cellar: :any, monterey:       "a2bba026efdb034044e7ec823496ff2efbc8b92103e086f78dbf70326e2eb82d"
    sha256 cellar: :any, big_sur:        "aaa167306934c3d4ee31c169d2c5a19c50d596d7025078f9713603313599098d"
    sha256 cellar: :any, catalina:       "044c6073f223d86ee52ca20af47cc3a08605dabd526090d772f3a18318b680fc"
    sha256               x86_64_linux:   "c3e593fb1fe1cdb1ec2453984d2893cc753e4fd96d2da444a0fddf5f53c1f526"
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
