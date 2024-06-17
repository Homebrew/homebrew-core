class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
  sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d56f271c1a03fb2bac4f8563099fed30aaacdf82ba99dd71be0645ca37a3a5a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d56f271c1a03fb2bac4f8563099fed30aaacdf82ba99dd71be0645ca37a3a5a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d56f271c1a03fb2bac4f8563099fed30aaacdf82ba99dd71be0645ca37a3a5a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4463c5cd654a225e4685fb4d90c66a384f8f445864b59e3c426a5d4418a2779e"
    sha256 cellar: :any_skip_relocation, ventura:        "4463c5cd654a225e4685fb4d90c66a384f8f445864b59e3c426a5d4418a2779e"
    sha256 cellar: :any_skip_relocation, monterey:       "4463c5cd654a225e4685fb4d90c66a384f8f445864b59e3c426a5d4418a2779e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56f271c1a03fb2bac4f8563099fed30aaacdf82ba99dd71be0645ca37a3a5a0"
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
