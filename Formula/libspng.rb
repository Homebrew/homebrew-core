class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.6.2.tar.gz"
  sha256 "eb7faa3871e7a8e4c1350ab298b513b859fcb4778d15aa780a79ff140bcdfaf3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "411793c20f2c46abda98b7bb47f87fe2bf42a4a05d1bb9fe5f87530a29f6975d"
    sha256 cellar: :any, big_sur:       "51acd1d38d45bcc408d59f08e3294f3a01e0c9cbaa8b78df8f4b3aa79d78f60c"
    sha256 cellar: :any, catalina:      "36b4b6258ffd843a84af75838b8adaa8add4c796966a3c2fab1ac1ba265be0f3"
    sha256 cellar: :any, mojave:        "65b9687a22d5f1af662bae1823c2a1fc38fb9a0fdf19bf4b3cb0725352499c87"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
