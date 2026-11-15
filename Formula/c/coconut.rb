class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "https://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/06/f4/38f315a1d8568257a74fe482e925368a2ef4bccc9b1d5751f003570bccc5/coconut-3.2.0.tar.gz"
  sha256 "0c64554deef3a35b2688368315cc2087dd8244e1b13d6b869fe5c2e679d6a0ad"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69bb75faa0d17adbcdede9b3b5dd61f6431584bb49f0adcb1de8268134121cc3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30506434e84de574edb173ae77d56d24a58401ba7f4f7143498f6776b9c571b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd6dc8fcb05ab81b665f03f956c7340ebf4ff416462b56d9bfd8f09feb7909ff"
    sha256 cellar: :any,                 arm64_linux:       "046ec68a9226676814f7ea21680ec15aa1f038370f27ebf45511c8596217f527"
    sha256 cellar: :any,                 x86_64_linux:      "0d6362a4d8e0df67da4280512c3b0699fdd5676c06a51e7d0a2d7da60fe257d3"
  end

  depends_on "python@3.15"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/a4/a4/b1519d785b1964ddde4bbb1a3675e5442c1af1dc4c6fe27d36adf54a97c4/cpyparsing-2.4.7.2.4.3.tar.gz"
    sha256 "e69499f9f84c89421ed642c0be5cb27e670a5b1b4eda6d21f64418d8baf13a38"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "tstr" do
    url "https://files.pythonhosted.org/packages/66/40/88e526174c65fe84552c5b920b0b7ec0787c52148106932cb72020561080/tstr-0.4.1.tar.gz"
    sha256 "bad326e07fe239eb4c63635964a6de9d55ff40ab223b04c6361b01c3b709523d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/69/4a/82d61476a1ccc20d43d0805724c5de4baa4971131a8db1816705ef53fe16/wcwidth-0.9.3.tar.gz"
    sha256 "dfe7cfbd4cb59db9fe0931bd6091ab4a95b3acc5d56bfb50fa9fef0ccba5dc5c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
