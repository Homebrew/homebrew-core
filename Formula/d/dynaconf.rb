class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/f3/11/a1cbc9bd1c07a5ef8254c969aa9f5549c8bc6bb38bbd369b2020df554bd1/dynaconf-3.2.3.tar.gz"
  sha256 "8a37ba3b16df64cb1db383eaad9c733aece218413be0fad5d785f7a907612106"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea3ea17268e70962f3068a0ce040797a7229bffe387c1ba279a81d539745e550"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb30eae2cf3ecd2be2f65b7ad701c6c9842aadb62ed3cad8e180e3e80d87d1a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dcd76c59dec51e236cfdbbf20c432cbc01532db7156e30924d520886b94db52"
    sha256 cellar: :any_skip_relocation, ventura:        "a08af654ce380561ecb933fbcb97b71f9020017d9506949883eb72e12cafa5ab"
    sha256 cellar: :any_skip_relocation, monterey:       "b16e7a578e4b9c68c0b8d8770334bc31649d8f04e699c1e1d31f69970d694f51"
    sha256 cellar: :any_skip_relocation, big_sur:        "df97b45a3380dfe0e110e57891d169c96b877cc9c9053b357bd3d652fc66ad55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718e55ee9e935b278df8973b9fda8c7534fa40feffe6e276d09344d2c830097d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
