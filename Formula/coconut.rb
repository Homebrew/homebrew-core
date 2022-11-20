class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/55/23/81b074bc722359a56131930673ce4e65f48a5c1ad538a79a77f346c77064/coconut-2.1.1.tar.gz"
  sha256 "38ce2c38c915e305e7c060a3e902d6ca8e504410182a0d4b50abe4df31aaebe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11c0ed966672b8aaecbb31b44b82d5b7449b777171587cc672d8053e98530d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecf8cf6c070c3544e4a42f66d29324801a61592b7962cf999b9d99dccd2918d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a682b82d886408092f4016074ea1265f85f4f60a98449e515ff92e7a901d4b2"
    sha256 cellar: :any_skip_relocation, ventura:        "c8f3528f15219a69ff5bd7488173c9b46506d6a974cec200e999b89fc5ea9976"
    sha256 cellar: :any_skip_relocation, monterey:       "1245f5925d66ab8f47bc2ec30dc3d277a29ff7140e464d056187ab52badcdf56"
    sha256 cellar: :any_skip_relocation, big_sur:        "6decbd6d1a45bf3479e2918bf7b7237f49f2b01cf77ed4537b0d8b2d1eb5bb5b"
    sha256 cellar: :any_skip_relocation, catalina:       "e98783cee8f73e6877bae04220729ee5499ae9c80157d72b1494a12dccb8678f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97f204375e49b763dced6c73ef8b2fd3c3c90a3ea237b1eb09b630d917bf5ec"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/c6/6a/b37f4aff8f53083fe71e9b5088dd3a413c231ece8dcb0809a8f2c2b5083e/cPyparsing-2.4.7.1.2.0.tar.gz"
    sha256 "c0dc51c5dbb6d5c1e672a60eb040b81dbebbab22b8560d026d9caebeb4dd8a56"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/e2/d9/1009dbb3811fee624af34df9f460f92b51edac528af316eb5770f9fbd2e1/prompt_toolkit-3.0.32.tar.gz"
    sha256 "e7f2129cba4ff3b3656bbdda0e74ee00d2f874a8bcdb9dd16f5fec7b3e173cae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
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
