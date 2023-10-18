class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.5.tar.xz"
  sha256 "705c6d29f4116a29bde4e36cfc1b046c92b6ef8c6dae4eaec85018747e6da5aa"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "27e4057e962e1491e667eca0801ef83963e293234d6517d33a9b1da6caf7be86"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    mkdir testpath/"test"
    touch testpath/"test/a"

    system bin/"mm-common-prepare", "-c", testpath/"test/a"
    assert_predicate testpath/"test/compile-binding.am", :exist?
    assert_predicate testpath/"test/dist-changelog.am", :exist?
    assert_predicate testpath/"test/doc-reference.am", :exist?
    assert_predicate testpath/"test/generate-binding.am", :exist?
  end
end
