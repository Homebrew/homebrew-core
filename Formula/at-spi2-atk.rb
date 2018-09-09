class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.30/at-spi2-atk-2.30.0.tar.xz"
  sha256 "e2e1571004ea7b105c969473ce455a95be4038fb2541471714aeb33a26da8a9a"

  bottle do
    cellar :any
    sha256 "a4d80ea77ada0be681e165d9bcf3836677036b9b7e7a2516475d015da37055fc" => :mojave
    sha256 "fa992dfbe9bcb014cb0d5bc3fa2700cd6cb51d82ff18a3998cde6b9fa3ea75a6" => :high_sierra
    sha256 "958cc79b52ac7917259dd5dd4dd47b770722447843b25ae4c8272b36efa868d8" => :sierra
    sha256 "01c0e01277843d36e5cacb8b8c07e1096f1a3c53d92ed49aba4af8a96e0e15dc" => :el_capitan
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
