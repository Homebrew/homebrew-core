class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/c2/d3/2c793df6cea96eda294daa400e4b6f06cd75b7a65005eb2c84aae2d08c5c/trove-classifiers-2024.1.31.tar.gz"
  sha256 "bfdfe60bbf64985c524416afb637ecc79c558e0beb4b7f52b0039e01044b0229"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c247f9f14bc569b742dce28810cc3e0a92bdb0f1492b9f03088ebc736ed143b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aad2e29a4bea87a1760499f9c1f9de2b19cfa371f95aeb046a9bc01fbf5ce6ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa112ef6da1d2fe907b5fa3faa013aa3ed800681e6306cf77249e98870b82e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "afd9e16beadd3778344a45cef727282a6140dc3bd1b1a521128b66238f752e23"
    sha256 cellar: :any_skip_relocation, ventura:        "d1e38ae4e5b5994b99e0732f84f0928868e333816f5143e7885638ac46fa2b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "5f7ab300dcce08fb378405b6d273969e22668c7300db077a81f6de26f1c1aa58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd29f515143efece92c750c859baa2c933a011430d7aaf65fb7d69f9bb242708"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end
