class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/38/6a/eb9721ed0929d0f55d167c2222d288b529723afbef0a07ed7aa6cca72380/yq-3.4.3.tar.gz"
  sha256 "ba586a1a6f30cf705b2f92206712df2281cd320280210e7b7b80adcb8f256e3b"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "78582756df6d73b461cb5d48153aa07693ba9966df4b870d2947c35ba65d96f3"
    sha256 cellar: :any,                 arm64_sequoia: "6fcc7e5152176d214b6ed0e8c310f1635b2276704b1cad2d2ee58438abe83ba5"
    sha256 cellar: :any,                 arm64_sonoma:  "18e8c8295b92643e711ffe3ca298dcb0157052a51e62550c24cac2aab67d1aee"
    sha256 cellar: :any,                 sonoma:        "0f215ad7173ff1309208dd0526c061d50f5b6b7838853b704fb1c9923473bdf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "524ae6c009837ecb5d6c6dab1d93038040d93dce3864c6de2fa477eb0f285806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece36385f46a4d31df2fd58129088085b20ca6a964dfb8b8b02b6ec90361e14c"
  end

  depends_on "jq"
  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/6a/aa/917ceeed4dbb80d2f04dbd0c784b7ee7bba8ae5a54837ef0e5e062cd3cfb/xmltodict-1.0.2.tar.gz"
    sha256 "54306780b7c2175a3967cad1db92f218207e5bc1aba697d887807c0fb68b7649"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           base_name: script, shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~YAML
      foo:
       bar: 1
       baz: {bat: 3}
    YAML
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
