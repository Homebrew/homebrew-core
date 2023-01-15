class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/03/a7/1d48279706b63a5928cfb0dda5152bd27ce914da05d31008b2fc252165e1/jello-1.5.5.tar.gz"
  sha256 "a7bc8762867db5c479323e308bd1d6074b5d5b0cafe3fdf340481764c7851487"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8702c22dc4ba1bcfeaf7e0245a362bd904fc0ad86c57b95b19db36aa6e1a3330"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8702c22dc4ba1bcfeaf7e0245a362bd904fc0ad86c57b95b19db36aa6e1a3330"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8702c22dc4ba1bcfeaf7e0245a362bd904fc0ad86c57b95b19db36aa6e1a3330"
    sha256 cellar: :any_skip_relocation, ventura:        "c6668ca389b6cd2c039515c27eee0f2e82b955d07634beba460b86062a634112"
    sha256 cellar: :any_skip_relocation, monterey:       "c6668ca389b6cd2c039515c27eee0f2e82b955d07634beba460b86062a634112"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6668ca389b6cd2c039515c27eee0f2e82b955d07634beba460b86062a634112"
    sha256 cellar: :any_skip_relocation, catalina:       "c6668ca389b6cd2c039515c27eee0f2e82b955d07634beba460b86062a634112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3a5c15eaefe8430f39a8b05a430f70e7d0cad61598c7bf23b3113e4f1eb1f0"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
