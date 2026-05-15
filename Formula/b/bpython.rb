class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/44/29/cd80e9108a6fc6a925ffb915f8f69198a2bb2388e39167a41d743ac2a8f4/bpython-0.26.tar.gz"
  sha256 "f79083e1e3723be9b49c9994ad1dd3a19ccb4d0d4f9a6f5b3a73bef8bc327433"
  license "MIT"
  revision 5
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cce6c6f772188ef46ddad79b6d43115d7c279892567a4e4b53e15770ba99478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "745fa18b9ea998fc0ea7fa986a15bba7b430f78226bb5e8fe46d7edf3f707d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9085432a5a5df8c0e2a9e987c646234a40210baf4f2538c1bd66f5449fe7b712"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aafb231a4cf6e28cfe38b1771d527d914505a8fb6f7595bcf55c67778b2e0d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2980d25601b1435747673d062fa280c9ba05333fd06064a6614d2a9f9da87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc75ebbaf667747932e49c79afa8bedae5c220e2da2d471d2964b4127415c552"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/94/ca/47457ccbfeac62002079ebc47509e1eccd5c8ec764c78975c7afd81c6b4a/blessed-1.39.0.tar.gz"
    sha256 "b04fc7141a20a3b2ade6cad741051f1e3ac59cc1e7e90915ed1f9e521332bea4"
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
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
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
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
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
