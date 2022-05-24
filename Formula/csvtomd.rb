class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8685baa5ab7f599731b2ce2e300efddd740fed6c786a371b725abebd5f2e72ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8685baa5ab7f599731b2ce2e300efddd740fed6c786a371b725abebd5f2e72ee"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed6b67a278e0266bda516a475867129cff5e93fad695f4e029e4119b199f123"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ed6b67a278e0266bda516a475867129cff5e93fad695f4e029e4119b199f123"
    sha256 cellar: :any_skip_relocation, catalina:       "2ed6b67a278e0266bda516a475867129cff5e93fad695f4e029e4119b199f123"
    sha256 cellar: :any_skip_relocation, mojave:         "2ed6b67a278e0266bda516a475867129cff5e93fad695f4e029e4119b199f123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d047da6a41a03db412406412f4741715b7446630a5ba5558fac8bda7b66668e9"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<~EOS
      column 1,column 2
      hello,world
    EOS
    markdown = <<~EOS.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}/csvtomd test.csv").strip
  end
end
