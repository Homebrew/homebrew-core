class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/54/6f/09c3ca2943314e0cae5cb2eeca1b77f5968855e13d6fdaae32c8e055eb7c/dynaconf-3.1.11.tar.gz"
  sha256 "d9cfb50fd4a71a543fd23845d4f585b620b6ff6d9d3cc1825c614f7b2097cb39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7cedcd2167d53c1edc2bcbc40f2810b117737802c72022c6e927fda9dfbd910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7cedcd2167d53c1edc2bcbc40f2810b117737802c72022c6e927fda9dfbd910"
    sha256 cellar: :any_skip_relocation, monterey:       "2ef3e5cc32bcd14bf1a39785cfca58826cef1e110d6ef22040da71aa8ee1fe4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ef3e5cc32bcd14bf1a39785cfca58826cef1e110d6ef22040da71aa8ee1fe4b"
    sha256 cellar: :any_skip_relocation, catalina:       "2ef3e5cc32bcd14bf1a39785cfca58826cef1e110d6ef22040da71aa8ee1fe4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e011ddd063e327fd8e7ce41c7571e0a344ebbc7642db30428659fc657ee0a4bd"
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
