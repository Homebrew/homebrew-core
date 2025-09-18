class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.7.tar.xz"
  sha256 "494abfce781418259b1e9d8888c73af4de4b6f3be36cc75d9baa8baa0f2a7a39"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b105ad896eeb16cfc9f158c87db7c4a63b03b3d58ae50fae9984b00feb02c24"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    mkdir testpath/"test"
    touch testpath/"test/a"

    system bin/"mm-common-prepare", "-c", testpath/"test/a"
    assert_path_exists testpath/"test/compile-binding.am"
    assert_path_exists testpath/"test/dist-changelog.am"
    assert_path_exists testpath/"test/doc-reference.am"
    assert_path_exists testpath/"test/generate-binding.am"
  end
end
