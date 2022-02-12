class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.4.tar.xz"
  sha256 "e954c09b4309a7ef93e13b69260acdc5738c907477eb381b78bb1e414ee6dbd8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea4a58e05333043201f42255d32ff54645f6443a221b093676b83d750954f35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ea4a58e05333043201f42255d32ff54645f6443a221b093676b83d750954f35"
    sha256 cellar: :any_skip_relocation, monterey:       "2ea4a58e05333043201f42255d32ff54645f6443a221b093676b83d750954f35"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ea4a58e05333043201f42255d32ff54645f6443a221b093676b83d750954f35"
    sha256 cellar: :any_skip_relocation, catalina:       "2ea4a58e05333043201f42255d32ff54645f6443a221b093676b83d750954f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc4b178ecf7b46ce823e3e99f056f5375859018a669cb93fbfe8ee7944ea162"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10"

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
