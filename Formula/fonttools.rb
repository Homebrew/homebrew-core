class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.2/fonttools-4.2.2.zip"
  sha256 "66bb3dfe7efe5972b0145339c063ffaf9539e973f7ff8791df84366eafc65804"
  revision 1
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "70dffdf243f46a90b41d8e82c49000bbed61109c9a8b3021b7a3f618a004fac1" => :catalina
    sha256 "f04b67b7b87402daa2ec6971a5cc87c16e25f221746f762c0fce43439bf82ef1" => :mojave
    sha256 "4c259ab4c718c77c77bce6dbfaeb2aa2b6664f786b5b7a3bfc16f8699d47791f" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
