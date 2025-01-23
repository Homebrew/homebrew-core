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
    sha256 cellar: :any,                 arm64_sequoia: "fc51885dc4afeb945b9da323e5ab75751a5b861f20c0523a79360343cf4f57db"
    sha256 cellar: :any,                 arm64_sonoma:  "8b33d265380df20b66a575e0b84592c86ba02422298dfb9a095fd46c407f913a"
    sha256 cellar: :any,                 arm64_ventura: "b7cfa07975355ba6d17eb32c40d7fc6ca2814de0ce84707e242bbf0050758902"
    sha256 cellar: :any,                 sonoma:        "148ae1e845bfbbc487ae9b2d152eaff0aca6650233a5c613fe06b1fddcf7ccf8"
    sha256 cellar: :any,                 ventura:       "509f944e20ed31d27571ae35409f52a3af4d2856295882edc4435bc2cd0243a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30bfa94a1f5bc51fffcfebb345afc1e4de7997833264112ce802774131b14278"
  end

  depends_on "jq"
  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/7f/03/581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0/argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/98/f7/d29b8cdc9d8d075673be0f800013c1161e2fd4234546a140855a1bcc9eb4/xmltodict-0.14.1.tar.gz"
    sha256 "338c8431e4fc554517651972d62f06958718f6262b04316917008e8fd677a6b0"
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
