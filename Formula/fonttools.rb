class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.43.2/fonttools-3.43.2.zip"
  sha256 "3a804bca2434776b6d9e39b54738d2232017b937ba1f86a5129ab756ad804263"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d670dd2ba2a8a4e0847c9029513c08b1d28425732b5c70f75751ee8e0fb53b78" => :mojave
    sha256 "d63ec871a286cb4a9e048bfdc2bc1957e589bcec96cad1356e7a7376aae87a3f" => :high_sierra
    sha256 "c22df18995cb790b64855c6633b30917b6e5078a4198e9256ac0ef40cd6c325d" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
