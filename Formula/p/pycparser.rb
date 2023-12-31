class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
  sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "165045d1d2983e38fadf1ef18feee98ad1342fb86a03e92542737f88fd271114"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c0a8359c68a9d6e8ce9a908c8eb096c412375a44a25417ded120a8a23053349"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc6da548931ec6819cc6d80ff062bfb522ca4619f1295076337da71eef851f69"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0489c6c4e0c24d77cb92db77b41c6f5225ad0718202fc8852715c6e092cb50a"
    sha256 cellar: :any_skip_relocation, ventura:        "06cd18b14c1c0a8a15b70f7bc46870f12d9f378c6832deadc7b92c43d2e3d7e8"
    sha256 cellar: :any_skip_relocation, monterey:       "e3fdde4e4812270abec33094173d13642d992cfb4a91518c398e54fc6b9a3625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26566af3b0704cb579e246f19bc9c1bf10e04322b5ad711c077c8f1759617e8c"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
    pkgshare.install "examples"
  end

  test do
    examples = pkgshare/"examples"
    pythons.each do |python|
      system python, examples/"c-to-c.py", examples/"c_files/basic.c"
    end
  end
end
