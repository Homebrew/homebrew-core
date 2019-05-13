class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.41.2/fonttools-3.41.2.zip"
  sha256 "2f0236403c76e29e5dd4ead7a22e7ef6e425b1bae48461366166c68d813d4384"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b76b3c8de188d61b93bd42e8d1f092793c2564c3e86d160edc54ad89283bc9f6" => :mojave
    sha256 "e86e9ec5b25e323fc86664d519aac6fbc44a22bf45a263553477e8470f4dab57" => :high_sierra
    sha256 "820d0e1920b397c6b040d0466dcfab96388f4b24b36148d0374f766307aeac21" => :sierra
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
