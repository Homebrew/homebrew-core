class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.3.0/fonttools-4.3.0.zip"
  sha256 "0c16d5da7846a92aedcb448277d13d3b729f7de48a917768d97ebd0d17067d7f"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "caa0e938b88ed6444b301c7b9783b7f00046b0a9316a49cd4d0de4525b2375e5" => :catalina
    sha256 "f738012e2248ac68aec204aa83d4a550a245ea1c602532618359c0ce87bafdac" => :mojave
    sha256 "970d9f5e5c6be12311dbce723843b7156b608e8f23992a06ec6c091d0d8d8466" => :high_sierra
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
