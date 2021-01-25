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
    sha256 "a416e9010403d5ee9e6c80ffa384a31b8989613109e9ceb047d48d2538f75ceb" => :big_sur
    sha256 "1b2bf5b4980df003eb2917c33583345183dad27ccf27663bf0aead7747ece3c4" => :arm64_big_sur
    sha256 "0848953327bb61223c30f3fc08c3cf8845c8e7387cafeaca31001967e990c2ae" => :catalina
    sha256 "82e99d77f2e543ebda262f6bf98cef0cfde5142a95a09a2374358f9ba7d3c781" => :mojave
    sha256 "292ce8133ff860d6083d049fa2e6d1cb357e8ce9c41453894fbba742ea7bdc20" => :high_sierra
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
