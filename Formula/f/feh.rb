class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.11.2.tar.bz2"
  sha256 "020f8bce84c709333dcc6ec5fff36313782e0b50662754947c6585d922a7a7b2"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ea2431b081ae0c1666b22c1978ae47d6c695fcae7c394d05a5f905830bef1052"
    sha256 arm64_sequoia: "8dae097b398a9333074c385533575743aec0b7e9769c6e11dcd339b8cfa936d0"
    sha256 arm64_sonoma:  "07849cd9a91b886ac818842e6a4f232f677536020849e70530c0571402a1df30"
    sha256 arm64_ventura: "d80fe37d32f46343483838ecde0b761abd6e392dcfc7ad65bebfeac907d06da6"
    sha256 sonoma:        "84875581a10cbd2c8842da604814f679d695d46e608d103b059544419e2e9bc2"
    sha256 ventura:       "952fe54cc54051f92b79a6831a23a3ca7305b6a1274131a702c213476edd1d8d"
    sha256 arm64_linux:   "23ff23d2b8b954cb4ba6312a11be3e1eeb08aa344424b5bb1012a4ac3bd947ee"
    sha256 x86_64_linux:  "fcd31189b116cf590d8e006fabd80fee8c32639d1b3b69f8865bbf6ae2728dda"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
