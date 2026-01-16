class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/software/diffutils/"
  url "https://ftpmirror.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz"
  mirror "https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz"
  sha256 "7c8b7f9fc8609141fdea9cece85249d308624391ff61dedaf528fcb337727dfd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "380bbf30a86eed3cc85348f32fc17062840a11a7b2e5568c3efeac866c191640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1439a94ab4fc8928a92a20d939e88ae0a77fb350a9d93e4d1101570a9590b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b9673616bcea3eb994a9b3afcb243f1b204f182c9aef25e6abf0c19eb79e2e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bc99b9d6cdfe12150ec8b91e22e0a73dd415f9a3272752638415db6747d4097"
    sha256 cellar: :any_skip_relocation, sonoma:        "710e012f9f4c1f2f4cbd489741e98ac26d3e48133bb5c1c2cad3d6e08d64a5d8"
    sha256 cellar: :any_skip_relocation, ventura:       "21df5472d1dabef143c9db748602efaf9acb5348a9f63e0ac364bd6562a9acb6"
    sha256                               arm64_linux:   "19f90006aba953a5396e794b938ae06a95f98ddcb56a505646ebe95ca0a56d07"
    sha256                               x86_64_linux:  "0d9d0320b98b399c0f3f1f0ec76b83192bbf74b393105b198c2322285ed08f12"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
