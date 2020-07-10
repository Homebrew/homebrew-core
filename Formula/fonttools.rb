class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.13.0/fonttools-4.13.0.zip"
  sha256 "63987cd374c39a75146748f8be8637634221e53fef15cdf76f17777676d8545a"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d30c6decd463bbdceb1475bdb555fd04d791867237dd6d05a428a4d719c842c" => :catalina
    sha256 "0aca64c1194c4a952f5bb30bd0c65c1ad5d2064346c7c20e6ae578543149213a" => :mojave
    sha256 "53971cbe63b47de282cbfd82b2155a78bb9c265a09c5b799f8a84b9b5bee525a" => :high_sierra
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
