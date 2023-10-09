class PythonToml < Formula
  desc "Python Library for TOML"
  homepage "https://github.com/uiri/toml"
  url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
  sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5823cab6f1438f69c06874397d39da3917e575d22a4f1cb9e6e8e04fa8cd9e76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aa1f3935e576153b39d941e3c25d824a3abdcb1f67ae3fff3705cc31af9a073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e347dc5d79b592b73b3074df15ace9c349169d7a24b51e3d258e4a769f521f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f44240277e9c6524287fffaf5fc3b22148fd2cdc80be6d5587e45eb92ded9f2b"
    sha256 cellar: :any_skip_relocation, ventura:        "356dd19a03e2bee0107ecdb5b3c9f9f85cb96f121a391088b333e3509bd78acf"
    sha256 cellar: :any_skip_relocation, monterey:       "87648197c14447e5c223991c36920f146996801917cc7a4cc4824239498a60a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea42d742ca9dc354ac30ffb377b5fcd37803b6c376a37ab66237f42ffca1b9e8"
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
