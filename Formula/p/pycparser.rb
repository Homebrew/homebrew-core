class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
  sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aa7ff23c989a3c34a0dd99938cfc2867b4796630cab4173f8590f2e159c1028"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3c397b487dd7cc2f3a43f1dce4d800a41774323fda80461d412291190db099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8ade22b7c9a96e85aaebf8addafbea91cf49279e172ce5ece105c0b7ce8727d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c66e05d7cdb3a008650023384a934c620864ef11458e2ba695233fe6d8c5a29"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a865aedc49c1aaacc009f9048e7743c494d62a5f3bad87042f6bd18469eb58"
    sha256 cellar: :any_skip_relocation, monterey:       "42f38be3a400209b84d6840494c1b23d8e6e03ad53f8db245d3069249115de4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07dbdd6e32af33650d0bcc5ecaa7b90623e47167aed9ef29f9aa5003987a0d69"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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
