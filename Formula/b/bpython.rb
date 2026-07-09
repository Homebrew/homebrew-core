class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/44/29/cd80e9108a6fc6a925ffb915f8f69198a2bb2388e39167a41d743ac2a8f4/bpython-0.26.tar.gz"
  sha256 "f79083e1e3723be9b49c9994ad1dd3a19ccb4d0d4f9a6f5b3a73bef8bc327433"
  license "MIT"
  revision 6
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99600adc9aa1fc6608bc0e8ec461116814b2a670c53fb0df0553ba8efc0ddbf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a641141089968a765d235d82c6bb1425412bbffadeb640995c6c6c5573ad5d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e47071bc0cde4cc167e1c7741d3b2f4c0292ebcd731db448b89639ed0b64290"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4ceef6472766528cc021432956652329f3c3f5109ec54447fc1ea1d7ab9df5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b3d9bd31f5ba12657b184598c497ab1bab286ee8a453b3348bf34a7607ca52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4452730f8698510e1d09a2b4681c525b2929999988ba8449a224c34637111c4"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/3b/02/603d04e776fca5258b476ae54fe6d73ce9633bc8ce21bb2142abd96c28c4/blessed-1.40.0.tar.gz"
    sha256 "2f90b531464769f039f6303b9352bed7e004698b5c881bb01abf5b0772dd5160"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/d1/18/5741cb42624089a815520d5b65c39c3e59673a77fd1fab6ad65bdebf2f91/curtsies-0.4.3.tar.gz"
    sha256 "102a0ffbf952124f1be222fd6989da4ec7cce04e49f613009e5f54ad37618825"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/86/5f/f5c3d1b4e9c8c541406ca0654efa1bfaa05414f8e7d1c14bc6e3fd0752f8/cwcwidth-0.1.12.tar.gz"
    sha256 "bfc16531d1246dd2558eb9b3a63aa37a9978672b956860dc5426da2343ebf366"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3c/3f/dbf99fb14bfeb88c28f16729215478c0e265cacd6dc22270c8f31bb6892f/greenlet-3.5.0.tar.gz"
    sha256 "d419647372241bc68e957bf38d5c1f98852155e4146bd1e4121adea81f4f01e4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/cb/eb/8821ce6e7386e96355f2c6be83944925b4a0870572896fd33a4e61b8aa5a/jinxed-2.0.0.tar.gz"
    sha256 "64b960b8f8d9966e1b2e7cb57ea2b1aa0a8d7e68045b96dc7ef58201e43a1209"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
