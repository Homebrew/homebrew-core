class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8fd8db04e6f8c5c164806d2c1b5fea6096daf583f83f06d1e4813ea61edc291f"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "1dc9e0d4ae5edd03013091933251474c8dcd4b1bc4f72a4df502734228c62f6f"
    sha256 cellar: :any, arm64_sonoma:   "df67721a4260dd63be5164d348ba57058f3a43298915726c7c1d0d3c43927794"
    sha256 cellar: :any, arm64_ventura:  "fa4ca77e9a2dd79350b705ec7cfcb559cce5e726777431b9a286ebb9b2ec00d2"
    sha256 cellar: :any, arm64_monterey: "b66abd39b5a6c8ee5b65603beb8e33357448af5a0fd8112610b63ffe6fc09df7"
    sha256 cellar: :any, sonoma:         "d9cd43c14cd780ac32cbd23e42b129db879e0dc6f1dd13e1b6d554845b46cc11"
    sha256 cellar: :any, ventura:        "eae81c50573f8ef3d0220e2237326bd8b712f15ed7c37cac40709feafdab7c86"
    sha256 cellar: :any, monterey:       "82f0ec08cfa698dafb97b18e8f5508c8648c9f1a80445c2077a3ab80168c7829"
    sha256               arm64_linux:    "1400c61fe5c429d51c0a3032a6f8a405503b89062b8082d7ab415466cff7f61f"
    sha256               x86_64_linux:   "9edc0fa1b1d9b411f896f492b1bc10fe2c8e85c70065212630f358b1c8d5d771"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "glib"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  # Apply open PR to fix build with recent `glib`. This restores behavior before
  # https://gitlab.gnome.org/GNOME/glib/-/commit/c583162cc6d7078ff549c72615617092b0bc150a
  # PR ref: https://github.com/dov/paps/pull/71
  patch do
    url "https://github.com/dov/paps/commit/e6ec698be127822661e31f7fca7d2e0107944b24.patch?full_index=1"
    sha256 "52848f9618dab9bc98c1554cc8a7a0b3ce419cfca53781b909d543ec4e4b27ea"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "--encoding=UTF-8", "-o", "paps.ps"
    assert_path_exists testpath/"paps.ps"
    assert_match "%!PS-Adobe-3.0", (testpath/"paps.ps").read
  end
end
