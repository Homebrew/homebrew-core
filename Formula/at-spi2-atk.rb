class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-atk/2.30/at-spi2-atk-2.30.1.tar.xz"
  sha256 "8b48ea5902a2b3e333ab21a2602e531e86bffbb8e58708b2a8a8dfa5d325bd6f"

  bottle do
    cellar :any
    sha256 "6622e03beadde94a89f5a7916480bba649e9b3cf6379dd6dd8399c08a27aeaf8" => :mojave
    sha256 "a6eeeb0fbd0094b0c9f85bf15f3cddaeb7de826f27630ba31a4dd8573f364464" => :high_sierra
    sha256 "c69b12100018e7eef4133520e58bbf8dbc0c4e709ab509a3dcd70834910e0913" => :sierra
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
