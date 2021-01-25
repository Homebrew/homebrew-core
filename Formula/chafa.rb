class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.6.0.tar.xz"
  sha256 "0706e101a6e0e806335aeb57445e2f6beffe0be29a761f561979e81691c2c681"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "a718785bfd6faedca36df68c304a6a6e8a2f3c6068398695967bc59135f53a30" => :big_sur
    sha256 "d4eb24678f6346e5663ae34e9b73fd840265de17cfec03365c0102a7c70515e6" => :arm64_big_sur
    sha256 "3bfa0808fb4930926de52cf2fbb8cdbfd6f9a19f88b564c2e20dc9b024a44f79" => :catalina
    sha256 "45a87d847913835738fb388155f12522d1b711eeb2e2b8c032664cef673fad57" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 4, output.lines.count
  end
end
