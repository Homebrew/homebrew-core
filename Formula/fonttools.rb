class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.0.2/fonttools-4.0.2.zip"
  sha256 "bb9bf6b5b4ded33e0d9f823e5ae2e1fa643af4d614915660abe3853a9a6931cd"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e25de527bc3ca605d5aa3d3bfed49f153527e6a517f53fb0faf1582bffef0ec" => :catalina
    sha256 "a3a13ac1d7e2ed4458050eeb4c6821c63f969adfee7aa93fa4dc774cd0446bb0" => :mojave
    sha256 "bf112d57e9bb3de65863317ed2ae3a9011f84db6fff06966368fec84f9c1647d" => :high_sierra
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
