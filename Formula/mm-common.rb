class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.3.tar.xz"
  sha256 "e81596625899aacf1d0bf27ccc2fcc7f373405ec48735ca1c7273c0fbcdc1ef5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b2bf5b4980df003eb2917c33583345183dad27ccf27663bf0aead7747ece3c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a416e9010403d5ee9e6c80ffa384a31b8989613109e9ceb047d48d2538f75ceb"
    sha256 cellar: :any_skip_relocation, catalina:      "0848953327bb61223c30f3fc08c3cf8845c8e7387cafeaca31001967e990c2ae"
    sha256 cellar: :any_skip_relocation, mojave:        "82e99d77f2e543ebda262f6bf98cef0cfde5142a95a09a2374358f9ba7d3c781"
    sha256 cellar: :any_skip_relocation, high_sierra:   "292ce8133ff860d6083d049fa2e6d1cb357e8ce9c41453894fbba742ea7bdc20"
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
