class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/1b/da/f6ec6a79f8dea70671f41d7162cfefdfe97e9c5b6c2227c1737183c05cd6/jc-1.25.5.tar.gz"
  sha256 "f8ac0e4bc427b0ee8a3bdb07a254cc9df6b6036cd440f6c425e2e519cdbda78a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1afb40e818b861d3a6d3db8aee6b98a1f0b3b29d408c96ab4ab6d1417183571a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d283b769ba50e6f01a9771f33f2df071c8dea6f80ddeb3e73e25cae1ca371ab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d283b769ba50e6f01a9771f33f2df071c8dea6f80ddeb3e73e25cae1ca371ab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d283b769ba50e6f01a9771f33f2df071c8dea6f80ddeb3e73e25cae1ca371ab6"
    sha256 cellar: :any_skip_relocation, sonoma:        "de7d28f7e778744293e40308f5e155665433ce7117ce070b857b9f5c0d17b4a1"
    sha256 cellar: :any_skip_relocation, ventura:       "de7d28f7e778744293e40308f5e155665433ce7117ce070b857b9f5c0d17b4a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d283b769ba50e6f01a9771f33f2df071c8dea6f80ddeb3e73e25cae1ca371ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d283b769ba50e6f01a9771f33f2df071c8dea6f80ddeb3e73e25cae1ca371ab6"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/6a/aa/917ceeed4dbb80d2f04dbd0c784b7ee7bba8ae5a54837ef0e5e062cd3cfb/xmltodict-1.0.2.tar.gz"
    sha256 "54306780b7c2175a3967cad1db92f218207e5bc1aba697d887807c0fb68b7649"
  end

  def install
    virtualenv_install_with_resources

    man1.install "man/jc.1"
    generate_completions_from_executable(bin/"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n",
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
