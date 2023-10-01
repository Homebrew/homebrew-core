class PythonToml < Formula
  desc "Python Library for TOML"
  homepage "https://github.com/uiri/toml"
  url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
  sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "106f42b699297e0f616d8793e7d5e7773e55f46221c570be211c5d8e44fbb6af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "834a2db12a6be2c576518cb07c20832abe43d65773d1ffd977ccd99da30bfa86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51ad6a3ace38bd7f76e7b6215b51798a1de6ded5c621acfe9e10d0bf44dcb75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3bb5124e9f72848f823cf130657f7b73846eae8e2d42355ef9b44e8d3c88143"
    sha256 cellar: :any_skip_relocation, sonoma:         "44184bc24b2fadd11c6d4374872775895009e37e031034c27a52ffa826e440be"
    sha256 cellar: :any_skip_relocation, ventura:        "cdd774d5f3199a7afabaaee113680d326772fd6c0915554f564b4b3fe0238323"
    sha256 cellar: :any_skip_relocation, monterey:       "2f7bf4095aecc3d0a50d08227af9fe573336e0a646bde2befa00d15d0f06fa02"
    sha256 cellar: :any_skip_relocation, big_sur:        "84e09d7ad852223141dfbdcdd55504b291c2c27bfbaffb30ef44b86d3fe40be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4af3afd961e422d62ca04300144dd06e722e617b8ca90d0e66177980d306c66"
  end

  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
