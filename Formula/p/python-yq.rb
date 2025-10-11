class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/38/6a/eb9721ed0929d0f55d167c2222d288b529723afbef0a07ed7aa6cca72380/yq-3.4.3.tar.gz"
  sha256 "ba586a1a6f30cf705b2f92206712df2281cd320280210e7b7b80adcb8f256e3b"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c1c48fe8fea4b75df063984531ab15a54af442a7de0e01d444794ccf3bd9bfc3"
    sha256 cellar: :any,                 arm64_sequoia: "fc51885dc4afeb945b9da323e5ab75751a5b861f20c0523a79360343cf4f57db"
    sha256 cellar: :any,                 arm64_sonoma:  "8b33d265380df20b66a575e0b84592c86ba02422298dfb9a095fd46c407f913a"
    sha256 cellar: :any,                 arm64_ventura: "b7cfa07975355ba6d17eb32c40d7fc6ca2814de0ce84707e242bbf0050758902"
    sha256 cellar: :any,                 sonoma:        "148ae1e845bfbbc487ae9b2d152eaff0aca6650233a5c613fe06b1fddcf7ccf8"
    sha256 cellar: :any,                 ventura:       "509f944e20ed31d27571ae35409f52a3af4d2856295882edc4435bc2cd0243a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5fd740b29833a5d142cb96772a21c8c4ee77384de3c3f781e1acc1e03b72727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30bfa94a1f5bc51fffcfebb345afc1e4de7997833264112ce802774131b14278"
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
