class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e3/c6/adfbfb59eda5d2eccf2e0af9e906b9919febe62bc444f2f5891944c2be9f/yq-3.2.3.tar.gz"
  sha256 "29c8fe1d36b4f64163f4d01314c6ae217539870f610216dee6025dfb5eafafb1"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "534922d4dc796a3527002c9fabfc51f01cf775c021adf99bfb2b959ece405779"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d438c01ebfccf527e7a51373f51f9cea74064d50cd86f894c6b95b89377314b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6c73cb19b674b6771f5917086015f8c14ea5fe4a1fdc7da10efdefb1ac83ccd"
    sha256 cellar: :any_skip_relocation, sonoma:         "633e99d25ff61721a19e1289bf9760577f1ec48eb62cba1feccd04e80fb1f25e"
    sha256 cellar: :any_skip_relocation, ventura:        "4a9f3f1f2eabcd6290e762106b89bc4f04dd7d31513411fb61a7c4208a501528"
    sha256 cellar: :any_skip_relocation, monterey:       "d03392dc88c85d2fa5b25c0c69528f44fb04141f747c0a64cd08500496215637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a7f3236ba42735197d91fdd43b650059d2e9c00475fb0f87d13a7faacca0ade"
  end

  depends_on "jq"
  depends_on "python-argcomplete"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources

    python_exe = Formula["python@3.11"].opt_bin/"python3.11"
    register_argcomplete = Formula["python-argcomplete"].opt_bin/"register-python-argcomplete"
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(
        python_exe, register_argcomplete, script,
        base_name:              script,
        shell_parameter_format: :arg
      )
    end
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
