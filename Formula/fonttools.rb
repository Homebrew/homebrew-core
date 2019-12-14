class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.2/fonttools-4.2.2.zip"
  sha256 "66bb3dfe7efe5972b0145339c063ffaf9539e973f7ff8791df84366eafc65804"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f9df7407e82899955ab1bd7bf7bd29b5692d718200beab1764a6068abc568bc" => :catalina
    sha256 "cb6d43dcea5b9b5dbeda509dcd8d6526637feba4227248056c58ed777d7279b7" => :mojave
    sha256 "22633503544a94e457d72217fc4d287e8e03117fb78c2eaadd93b8b00608c64d" => :high_sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
