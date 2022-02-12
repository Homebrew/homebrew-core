class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.4.tar.xz"
  sha256 "e954c09b4309a7ef93e13b69260acdc5738c907477eb381b78bb1e414ee6dbd8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0753684dbf7615426643a2bb78d83b487da30f8274a09c4faf49d6200c5ec14f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0753684dbf7615426643a2bb78d83b487da30f8274a09c4faf49d6200c5ec14f"
    sha256 cellar: :any_skip_relocation, monterey:       "0753684dbf7615426643a2bb78d83b487da30f8274a09c4faf49d6200c5ec14f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0753684dbf7615426643a2bb78d83b487da30f8274a09c4faf49d6200c5ec14f"
    sha256 cellar: :any_skip_relocation, catalina:       "3a57404ead5025c9860efdd96a5ce3bca0cc4c577c4a62bed893221f16c954ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d669050d610b82d1079a9c6a1659c93b76954e23b03ae84d7b1b610d034655"
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
