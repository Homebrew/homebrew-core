class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/ff/4e/36a6e77f8c49b2b993d9ff0245a031065435998df6f018fc1f5de16ef884/fonttools-4.29.0.zip"
  sha256 "f4834250db2c9855c3385459579dbb5cdf74349ab059ea0e619359b65ae72037"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a4b5eb00742c3a4c1fba336ab327a4f01d0cd2346ab7be02a2825b0a10f994"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4a4b5eb00742c3a4c1fba336ab327a4f01d0cd2346ab7be02a2825b0a10f994"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4ec71512fed265821d5d0ab83ad6f1301a51cba88b3a3df91fb4de39949183"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b4ec71512fed265821d5d0ab83ad6f1301a51cba88b3a3df91fb4de39949183"
    sha256 cellar: :any_skip_relocation, catalina:       "8b4ec71512fed265821d5d0ab83ad6f1301a51cba88b3a3df91fb4de39949183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d95b9e85a63718880a96c254f2a0a988c7d64b56de2cc912b15941aa92eabcf"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
