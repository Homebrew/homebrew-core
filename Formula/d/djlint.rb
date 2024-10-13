class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/a4/ee/ac8ee551ec04d5a214e62d008f40bf309574f103416482e03fb61fbad61c/djlint-1.35.2.tar.gz"
  sha256 "318de9d4b9b0061a111f8f5164ecbacd8215f449dd4bd5a76d2a691c815ee103"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "091bed21d32b9ff2262763230a9868cf6daaba98990ce743c6f96362ffc83058"
    sha256 cellar: :any,                 arm64_sonoma:  "cd671663ffd2b3f74bacc3f8e283be9d56db4d7d2a4830dfaa5cb94b344b54dd"
    sha256 cellar: :any,                 arm64_ventura: "e5475003140e226d0a878349272351cf2646e31916c8476e6cf33555cc7f9e12"
    sha256 cellar: :any,                 sonoma:        "e2e31dc4a8f0b68e47f01100fbba2a4101581832e39fb5070779fe867c7a361a"
    sha256 cellar: :any,                 ventura:       "93f1475e06b2ab21badf46c9d32285df5d2526fda2842a63b6ca135d8624a81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d6f788dc20965e44d4f19d1610ef237cef267aaff1b6b720dbfddb9e3a931b"
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

  resource "html-tag-names" do
    url "https://files.pythonhosted.org/packages/41/7c/8c0dc3c5650036127fb4629d31cadf6cbdd57e21a77f9793fa8b2c8a3241/html-tag-names-0.1.2.tar.gz"
    sha256 "04924aca48770f36b5a41c27e4d917062507be05118acb0ba869c97389084297"
  end

  resource "html-void-elements" do
    url "https://files.pythonhosted.org/packages/80/5c/5f17d77256bf78ca98647517fadee50575e75d812daa01352c31d89d5bf2/html-void-elements-0.1.0.tar.gz"
    sha256 "931b88f84cd606fee0b582c28fcd00e41d7149421fb673e1e1abd2f0c4f231f0"
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
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
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
