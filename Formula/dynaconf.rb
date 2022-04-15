class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/2c/45/76c978c725b020be65a95b8b427e3550c76478a90e5396a33b0b204cae45/dynaconf-3.1.8.tar.gz"
  sha256 "d141a6664fca3648d2d8e84440966af9f58c4f4201ca78353a3f595a67c19ab4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c29b1041d65f3e3681269e8bd8e10d1d7aa5777de261c93ebf78fe0490aaeea9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c29b1041d65f3e3681269e8bd8e10d1d7aa5777de261c93ebf78fe0490aaeea9"
    sha256 cellar: :any_skip_relocation, monterey:       "dfdc9796f1364ba9713577378b6cf1d3056f3776fa7bcf6a79038c8823fd5908"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfdc9796f1364ba9713577378b6cf1d3056f3776fa7bcf6a79038c8823fd5908"
    sha256 cellar: :any_skip_relocation, catalina:       "dfdc9796f1364ba9713577378b6cf1d3056f3776fa7bcf6a79038c8823fd5908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0515e8630c6f13cdc4fc43e07e4ee5b45df17d9fbdaa033c925788cd829c5e20"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
