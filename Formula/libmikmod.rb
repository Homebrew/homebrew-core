class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.11.1/libmikmod-3.3.11.1.tar.gz"
  sha256 "ad9d64dfc8f83684876419ea7cd4ff4a41d8bcd8c23ef37ecb3a200a16b46d19"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "74a5601641751f0e90dd3a5a274a257161c26b86443e77f2d605b3be9ff67115"
    sha256 cellar: :any,                 arm64_big_sur:  "59bf02931bcc7553745595b3859277cbb471ef5cf6f644a9251ddde4fc8a9513"
    sha256 cellar: :any,                 monterey:       "f427b1ed15b6298b45e7d18564899b9cdb2ca57d2d01b7de4aed03c4a3be32c5"
    sha256 cellar: :any,                 big_sur:        "7f99f24d853fa01e073fe73cecabf1a8ec8f871f354e21da5b5003bc2de85ad2"
    sha256 cellar: :any,                 catalina:       "2151c9e70ca92a911af8cf769c18541c5d107df349b44987f716909c67216c59"
    sha256 cellar: :any,                 mojave:         "c69fe0dbab9fb93187e1388d4e388c00c73930dfb3bdd668a0a60228cd8d681b"
    sha256 cellar: :any,                 high_sierra:    "062f1a9e2c4d5ebc6cfb08e70abbdf4ebd85b06519345ed8bde301e62d0cd860"
    sha256 cellar: :any,                 sierra:         "f7785b9a4f95ff28d55ffd022780ed1cd9bde139b3482cc4f52b862cd9abf247"
    sha256 cellar: :any,                 el_capitan:     "202b59906b8113d694f9c1e81df7a5f00f8afbc9e66a2b1188674058a64ae206"
    sha256 cellar: :any,                 yosemite:       "8276808d976d108dd2768cacb5b54bf570ef6662b8855e7d3537e0ffaaeb1a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "389de6e5bc42ac2a6813b283c4ddbc2312d915beafe93305d8b2bd474deca2a9"
  end

  def install
    mkdir "macbuild" do
      # macOS has CoreAudio, but ALSA, SAM9407 and ULTRA are not supported
      system "../configure", "--prefix=#{prefix}", "--disable-alsa",
                             "--disable-sam9407", "--disable-ultra"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
