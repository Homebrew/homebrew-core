class Plotjuggler < Formula
  desc "Visualize time series that is fast, powerful and intuitive"
  homepage "https://github.com/facontidavide/PlotJuggler"
  url "https://github.com/facontidavide/PlotJuggler.git", tag: "3.7.1", revision: "fb2bab446f63c726f85e71b155d9fcbeb5603dc1"
  license "MPL-2.0"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "mosquitto"
  depends_on "pcre2"
  depends_on "protobuf@21"
  depends_on "qt@5"
  depends_on "webp"
  depends_on "xz"
  depends_on "zeromq"
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_PREFIX=install"
    system "cmake", "--build", "build", "--config", "RelWithDebInfo", "--parallel", "--target", "install"
    libexec.install Dir["install/bin/*"]
    bin.install_symlink libexec/"plotjuggler"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plotjuggler --version")
  end
end
