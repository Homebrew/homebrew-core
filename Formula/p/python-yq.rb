class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/38/6a/eb9721ed0929d0f55d167c2222d288b529723afbef0a07ed7aa6cca72380/yq-3.4.3.tar.gz"
  sha256 "ba586a1a6f30cf705b2f92206712df2281cd320280210e7b7b80adcb8f256e3b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ade8952a20185a727c65adba3cc9100db7c6ed46f4b78653c4f60679959fbb6f"
    sha256 cellar: :any,                 arm64_sonoma:  "5ec0178c6e5ee1139e49a6275be61c242faef98fd91ce6dc53640e7ee38bbc9f"
    sha256 cellar: :any,                 arm64_ventura: "5135368b4db7fb4941565644e449afacb335ca008233e09096b27a5ab50d777a"
    sha256 cellar: :any,                 sonoma:        "cfa479a7ce3064fda290a1261ede523276defe5ee60260a18982722d9a1cf106"
    sha256 cellar: :any,                 ventura:       "ad2827c9e10e68e5a58e3bf6c34534c380b66dd16122ffec1b68b59b03546fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a31d246270aa8b514e914937f3ab9d22fd2d4bdd10e7a88e229bd7749ed81a5"
  end

  depends_on "jq"
  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
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
                                           shell_parameter_format: :arg)
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
