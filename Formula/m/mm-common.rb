class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.6.tar.xz"
  sha256 "b55c46037dbcdabc5cee3b389ea11cc3910adb68ebe883e9477847aa660862e7"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "51e28647cb23b6c7259a8487adf36301731684c5d12bdccba36247ef0603312f"
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
