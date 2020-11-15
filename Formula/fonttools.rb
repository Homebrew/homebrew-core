class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.17.0/fonttools-4.17.0.zip"
  sha256 "5773ceed7e4a18b26c03888b148066afb13ad830e5afd3509d3c282f01dcda4c"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8df733edfcca97a2ea9f608c3c49c0042d5e5f16ce75f618c48b1341ef41ac02" => :big_sur
    sha256 "c0fc8efd6caaabf9b3340e2eb6d84ebba1f4065e7f82869262f4fb69dfbe115b" => :catalina
    sha256 "ec3b0c20e2f9517ff3037e07b07881e4d8d4e0a765735bb6a136635ae6d13112" => :mojave
    sha256 "ee8e0c4b45dcbeb31f147907e257a1478972dca701556755a8149510245f571c" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
