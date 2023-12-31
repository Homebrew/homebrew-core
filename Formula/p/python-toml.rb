class PythonToml < Formula
  desc "Python Library for TOML"
  homepage "https://github.com/uiri/toml"
  url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
  sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57b140924ebf038fc6be631b0e726811e175a6751e0eaef531bcb575563e6953"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6378bb124b086911f75827191b113b008cbb943b1ce70c17980227ea691faa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c84849d0cf0e493c73d2a6ed4559822da97f756867c27bb09479f53c7414ae15"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d148c21c6298c705fc41679ad75845eebd59cc7fd48b0d97b061aa7df74252d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8d1c6987cf0aa91142fa595e705192208f69914bb0a0129e0850a73f00ae6a6"
    sha256 cellar: :any_skip_relocation, monterey:       "d291249e24e8b26d9266e5f24614da31ea450f99dfc861ad90b3fe924fd31a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1661e6b18ca6c7ac081e4ba72170c4ff13d53bc228455494e80cef7b4d7789a"
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
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~PYTHON
        import toml
        toml_string = """
        title = "TOML Example"
        """
        parsed_toml = toml.loads(toml_string)
      PYTHON
    end
  end
end
