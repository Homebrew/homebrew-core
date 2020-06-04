class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.1.tar.xz"
  sha256 "28a2d775afbf05c5c957b24b220ed6e9b2023179b98ecde471d89e9754ea5ac9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f39efe929465c1035f91d2a71e313a7d96f8644d052a057a87d62ae7173720e7" => :catalina
    sha256 "f39efe929465c1035f91d2a71e313a7d96f8644d052a057a87d62ae7173720e7" => :mojave
    sha256 "f39efe929465c1035f91d2a71e313a7d96f8644d052a057a87d62ae7173720e7" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8"

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
