class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.26/at-spi2-atk-2.26.2.tar.xz"
  sha256 "61891f0abae1689f6617a963105a3f1dcdab5970c4a36ded9c79a7a544b16a6e"

  bottle do
    cellar :any
    sha256 "55378269fb96de1448cb89ab226da2138503b713875d6ce009b455a52e1b3023" => :high_sierra
    sha256 "6d815c2cf4ffc7881f884e3a9b80771a3150a1c43aecb56fdf8b7f94e4bc17e8" => :sierra
    sha256 "574185424627a2c24041e448c77df13f57e614b08ff74371d29e6177557ba938" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
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
