class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.3.tar.xz"
  sha256 "e81596625899aacf1d0bf27ccc2fcc7f373405ec48735ca1c7273c0fbcdc1ef5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f40a6de3865dbb9c453f82b2eae422bb54ae0e422ee287ad41cea24f4b084937"
    sha256 cellar: :any_skip_relocation, big_sur:       "f40a6de3865dbb9c453f82b2eae422bb54ae0e422ee287ad41cea24f4b084937"
    sha256 cellar: :any_skip_relocation, catalina:      "85f048b6c104120336d3d1e727ddef7faca85feaad37bb404f502202437d1a41"
    sha256 cellar: :any_skip_relocation, mojave:        "85f048b6c104120336d3d1e727ddef7faca85feaad37bb404f502202437d1a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015f6833761b100ad4610a505700d44fc1db448147f68ae502cc8e9383048ef9"
    sha256 cellar: :any_skip_relocation, all:           "f40a6de3865dbb9c453f82b2eae422bb54ae0e422ee287ad41cea24f4b084937"
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
