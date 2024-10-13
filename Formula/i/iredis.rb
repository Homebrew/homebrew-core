class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https://iredis.xbin.io/"
  url "https://files.pythonhosted.org/packages/7a/80/ac86d397fa0b931cfa0121ed23549a245e706b4b34e4bfc491bcd4123acf/iredis-1.15.0.tar.gz"
  sha256 "70c3c3d260c1f1a49145b3242a054ae1a5142021d49c72c199760874ab2c069c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/laixintao/iredis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "57ddd6507962ae44cffea2d4cbb8e173002f5d97c99e4151f0d5bcc7b7a86498"
  end

  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/ef/c8/f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628/mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/2d/4f/feb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127/prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/e0/58/dcf97c3c09d429c3bb830d6075322256da3dba42df25359bd1c82b442d20/redis-5.1.1.tar.gz"
    sha256 "f6c997521fedbae53387307c5d0bf784d9acc28d9f1d058abeac566ec4dbed72"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    port = free_port
    output = shell_output("#{bin}/iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end
