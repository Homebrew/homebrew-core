class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8fd8db04e6f8c5c164806d2c1b5fea6096daf583f83f06d1e4813ea61edc291f"
  license "LGPL-2.0-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8d95f99591217a56718331ee68a6996b39f059ca4aecfe5d0921a11566d75735"
    sha256 cellar: :any, arm64_sequoia: "b26fed1929f8d01dac18fb575c540f386006b2db8ce860288001f1424b3e6baa"
    sha256 cellar: :any, arm64_sonoma:  "e3679db03c165c79cdbb9a8ceac9fc0df4f3226622590452249e076e38ebe0ff"
    sha256 cellar: :any, sonoma:        "183b02cb1d125fa77ad0320bd003589aa346d9077d530ab85779916c41503547"
    sha256               arm64_linux:   "f8bff76dd84fc102e71509567f16a62036320efb8d3fb10240cee22ae5b70d19"
    sha256               x86_64_linux:  "cf456bd3c1d9da480517bda9f2bf04ca1545c409538e802caba1c11411329029"
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

  # Fix compatibility with fmt 12.
  # https://github.com/dov/paps/pull/77
  patch do
    url "https://github.com/dov/paps/commit/a26a20d7ca3feb08476a8a19fd97c3ececcc1e2e.patch?full_index=1"
    sha256 "604bc9e60b33162b522d18f251e3436745ca20b39a763202cfc7660423d9a9fe"
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
