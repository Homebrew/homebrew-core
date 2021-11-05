class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/d5/41/cafdf42a67ff794d912960952fec7c481b2470ee29f1c671df8c19bd84a9/fonttools-4.28.0.zip"
  sha256 "a5a09dacac7dd8037957f97d0377f862b1ff862ba8d4d3f6182bc23a4b549c7a"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65efa10b0d79980cf764344216335374c25bb7b8d6fab762a4864b736b3fb032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65efa10b0d79980cf764344216335374c25bb7b8d6fab762a4864b736b3fb032"
    sha256 cellar: :any_skip_relocation, monterey:       "3591897c765569aee11951cddd69b1515bacaa87b9a686e1d9e80a7a87c9b7f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3591897c765569aee11951cddd69b1515bacaa87b9a686e1d9e80a7a87c9b7f0"
    sha256 cellar: :any_skip_relocation, catalina:       "3591897c765569aee11951cddd69b1515bacaa87b9a686e1d9e80a7a87c9b7f0"
    sha256 cellar: :any_skip_relocation, mojave:         "3591897c765569aee11951cddd69b1515bacaa87b9a686e1d9e80a7a87c9b7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a929e130230b40b124171e2ca174d6c9caf2d7a210585386cf0a1e06e445fcf"
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
