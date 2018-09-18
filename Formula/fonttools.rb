class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.30.0/fonttools-3.30.0.zip"
  sha256 "95e86519b18183dc3c230e9b2233a69add3f631ec43c8725a553844a7d12c2c4"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00430eef1d01782d4ed3919adbb93c55f62788356fd9eb417eed72c0d4dfa00a" => :mojave
    sha256 "8182d441738a92f27c590d7c566f5eaa873ed3c9e57ad9071d805e7244a86df3" => :high_sierra
    sha256 "6030f7ed2286083fa03f9b7fb5f3eab521655fc19efd57cb7a53b4cf93874a0e" => :sierra
    sha256 "f2bb6b5c488f1db4b55d63626f2603927d697192234ce44b2d826416280b09e4" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python@2"
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
