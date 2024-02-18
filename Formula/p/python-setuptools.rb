class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
  sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91af6c9d0f2485a1a125f2049935c081091da2fb2828f4f4c3fe9ffcd13a0fe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "844769eef633985f5c61f864b2d4e72d8b2f06b6d080f382810928a971e82a2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b158ffaa18eb0fd73fd6fb355e8d9cb43de514357a432bcaacd17e37b7379182"
    sha256 cellar: :any_skip_relocation, sonoma:         "25f0c2cc441f9a8763f843101a03943a59640cd1cabde7aff560d39493417072"
    sha256 cellar: :any_skip_relocation, ventura:        "d9fd2e627aa934ed7ded37760323084548533ba62ae17e66c95affb452793da0"
    sha256 cellar: :any_skip_relocation, monterey:       "b49f840630ba5f0183bb424f0c19343d79b35031cda4a8f8577052d5ec0fc070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5374646e21c19ed1d4102dd68ac5b14cc8871eda5e537a6a05d71a71d200dd4d"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
