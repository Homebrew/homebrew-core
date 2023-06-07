class BrewPip < Formula
  include Language::Python::Shebang

  desc "Install pip packages as homebrew formulae"
  homepage "https://github.com/hanxue/brew-pip"
  url "https://github.com/hanxue/brew-pip/archive/0.4.1.tar.gz"
  sha256 "9049a6db97188560404d8ecad2a7ade72a4be4338d5241097d3e3e8e215cda28"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d3524a3e54dfbedbf7cb89078d07ce62131c7d01ad413b9a299c21f68325642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d3524a3e54dfbedbf7cb89078d07ce62131c7d01ad413b9a299c21f68325642"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d3524a3e54dfbedbf7cb89078d07ce62131c7d01ad413b9a299c21f68325642"
    sha256 cellar: :any_skip_relocation, ventura:        "d06a7bf79cd911d10bb3dc6679a7e47fb61b0beaa3ab86eb75dd6ef6d1c67823"
    sha256 cellar: :any_skip_relocation, monterey:       "d06a7bf79cd911d10bb3dc6679a7e47fb61b0beaa3ab86eb75dd6ef6d1c67823"
    sha256 cellar: :any_skip_relocation, big_sur:        "d06a7bf79cd911d10bb3dc6679a7e47fb61b0beaa3ab86eb75dd6ef6d1c67823"
    sha256 cellar: :any_skip_relocation, catalina:       "d06a7bf79cd911d10bb3dc6679a7e47fb61b0beaa3ab86eb75dd6ef6d1c67823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3524a3e54dfbedbf7cb89078d07ce62131c7d01ad413b9a299c21f68325642"
  end

  # Repository is not maintained in 9+ years
  deprecate! date: "2022-04-16", because: :unmaintained

  depends_on "python@3.11"

  def install
    bin.install "bin/brew-pip"
    rewrite_shebang detected_python_shebang, bin/"brew-pip"
  end

  test do
    system "#{bin}/brew-pip", "--help"
  end
end
