class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/eb/ff/c3a7ee0c22703c03132737d1021b3c75fe1a8cfc852ce03fe74842c12966/djlint-1.36.1.tar.gz"
  sha256 "f7260637ed72c270fa6dd4a87628e1a21c49b24a46df52e4e26f44d4934fb97c"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78219ea6bb1a185b5575a140c55616bdaab17e8b6ec37badd723c7409b9dca9e"
    sha256 cellar: :any,                 arm64_sonoma:  "38f1457fc7dd2606bb59a67969a9b78fa1651481d460637332b4caf87ad3665d"
    sha256 cellar: :any,                 arm64_ventura: "d9f682f49fb07fa053cfd076f748f9d742b14bcc701426f4b769486fb720f9de"
    sha256 cellar: :any,                 sonoma:        "7d96f1d76ce62098ed3179538a79a07e5968c12d55f451e6520e3793d40a147c"
    sha256 cellar: :any,                 ventura:       "2379979f4a81273b9cbbcb3eb7e3338a6541de99966a9284b714ff22d4996260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a120d347fd0caf802f333789c6c4961c2ef6c98a14e83849d60139fc1f24f61"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssbeautifier" do
    url "https://files.pythonhosted.org/packages/e5/66/9bfd2d69fb4479d38439076132a620972939f7949015563dce5e61d29a8b/cssbeautifier-1.15.1.tar.gz"
    sha256 "9f7064362aedd559c55eeecf6b6bed65e05f33488dcbe39044f0403c26e1c006"
  end

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/3d/85/7b5c2fac7fdc37d959fab714b13b9acb75884490dcc0e8b1dc5e64105084/EditorConfig-0.12.4.tar.gz"
    sha256 "24857fa1793917dd9ccf0c7810a07e05404ce9b823521c7dce22a4fb5d125f80"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/69/3e/dd37e1a7223247e3ef94714abf572415b89c4e121c4af48e9e4c392e2ca0/jsbeautifier-1.15.1.tar.gz"
    sha256 "ebd733b560704c602d744eafc839db60a1ee9326e30a2a80c4adb8718adc1b24"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/91/59/51b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbc/json5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e8/4f/0153c21dc5779a49a0598c445b1978126b1344bab9ee71e53e44877e14e0/tqdm-4.67.0.tar.gz"
    sha256 "fe5a6f95e6fe0b9755e9469b77b9c3cf850048224ecaa8293d7d2d31f97d869a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_includes shell_output("#{bin}/djlint --version"), version.to_s

    (testpath/"test.html").write <<~EOS
      {% load static %}<!DOCTYPE html>
    EOS

    assert_includes shell_output("#{bin}/djlint --reformat #{testpath}/test.html", 1), "1 file was updated."
  end
end
