class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.2.tar.xz"
  sha256 "a2a99f3fa943cf662f189163ed39a2cfc19a428d906dd4f92b387d3659d1641d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8c0ecc8d52d9bb2c9f90341fbfaf9013abb1aa31308a1c601b1afc356f2246ab" => :catalina
    sha256 "acbd3eb9fc8c3b1d91eedee2d89119f10cd7aae5e1cfbe8eb3e80bb4f53d79ea" => :mojave
    sha256 "baf753d8db7373f6c117ed53856c288a934f529435117a68ea040832a807a9df" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
