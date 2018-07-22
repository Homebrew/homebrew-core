class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.28.0/fonttools-3.28.0.zip"
  sha256 "ebf2ee25a6060e8551880a3b05d6ecadcdcfbd1b32fc272ff7b3acdb22945b6f"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6b33682edc7322212e08eba4ee54f8ff27239dadb7e58bf61a2b06d52107318" => :high_sierra
    sha256 "f017b82450af6fbf4e29c8465257c2500457036e4f430e5c92a1c3459f20966f" => :sierra
    sha256 "3c44b98671ac8b9c4069a1c6cf828e7616b2063b632d9e4eff0ce236e69a3055" => :el_capitan
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
