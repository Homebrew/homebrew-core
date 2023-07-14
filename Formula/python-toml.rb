class PythonToml < Formula
  desc "Python Library for TOML"
  homepage "https://github.com/uiri/toml"
  url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
  sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  license "MIT"
  head "https://github.com/uiri/toml.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96e51e41b34e32f8b186368deb71ead8c489d8dddf6e0d13bfbef3ef3fd12b99"
  end

  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", "--prefix=#{prefix}", "--no-deps", "--no-index", "--find-links=.", "."
  end

  test do
    system python3, "-c", <<~PYTHON
      import toml
      toml_string = """
      title = "TOML Example"
      """
      parsed_toml = toml.loads(toml_string)
    PYTHON
  end
end
