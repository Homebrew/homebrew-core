class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "https://github.com/zevv/duc"
  url "https://github.com/zevv/duc/releases/download/1.4.6/duc-1.4.6.tar.gz"
  sha256 "e91592e367f3f8be671899660756b25e2c37f316c42ebd2a36dd684be3e2f25a"
  license "LGPL-3.0-only"
  head "https://github.com/zevv/duc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bb01ec4d71dab368193198a600df30283f0e4ebb59bb92b5fee3640d2de14c7"
    sha256 cellar: :any,                 arm64_sequoia: "41cc6c35c2c0291137556ddd2c07e7d690cdac67b5cd220c0935ee3a19a20aef"
    sha256 cellar: :any,                 arm64_sonoma:  "b1e742ed404fbda890970be4142e17b7018f6007e63cd572c9dfe9afab2f4d8b"
    sha256 cellar: :any,                 sonoma:        "f6ce54596642aa6f8dc27eb66d54f6dd2d6238dae6ecac8c225ee91b5b66bb2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88cc0ddde0081d9ca14f4d036f5f48b10ca1616543d7c1eed8b2ec5b47a4ad88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc33d230b1c8a087e12c7a81c85e9723f58e2e90bba7cdc33f0876f845a9ca1"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glfw"
  depends_on "glib"
  depends_on "pango"
  depends_on "tokyo-cabinet"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-x11",
                          "--enable-opengl",
                          *std_configure_args
    system "make", "install"
  end

  test do
    db_file = testpath/"duc.db"
    touch db_file
    system "dd", "if=/dev/zero", "of=test", "count=1"
    system bin/"duc", "index", "-d", db_file, "."
    system bin/"duc", "graph", "-d", db_file, "-o", "duc.png"
    assert_path_exists testpath/"duc.png", "Failed to create duc.png!"
  end
end
