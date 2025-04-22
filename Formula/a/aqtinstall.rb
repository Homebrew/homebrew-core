class Aqtinstall < Formula
  include Language::Python::Virtualenv

  desc "Another unofficial Qt installer"
  homepage "https://github.com/miurahr/aqtinstall"
  url "https://files.pythonhosted.org/packages/de/c6/4e122b226120407b76b473433b24a7628853ce4c4405ed3d56d52f8e6a9e/aqtinstall-3.2.1.tar.gz"
  sha256 "80005d4f8eebd50487a87fec2de4d4f808bb72fc923026eef9e3575795f801bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bae085ca061fadbcbf0d15c6e1fc5a36776dd51e62161bd89e0a2b05e786b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18587357a412fa3e04beb885a50eda950ff5346e682ac082612548a35b7a5ca9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "602f0515af58cced1f36ac5e133172e40f7c8a19df70dd544cf5c224f607410d"
    sha256 cellar: :any_skip_relocation, sonoma:        "25dbc8e783e9558de958fca4a5b88ed4d00be16633762117ab966d5c78a9918d"
    sha256 cellar: :any_skip_relocation, ventura:       "d404a32e21f3a5e5bdc86f316afc0577e21605db9fa4af30a6d26dc28ccf4e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aff64375ab227d6ce03b552d0cf448d8fd5c6bdb422832788b5534fc652ff9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ebd32bd548797fff9f1d3d66d72941a6bf61fead384f965fded846449fd490f"
  end

  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/f0/3c/adaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439/beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/1c/ab/c9f1e32b7b1bf505bf26f0ef697775960db7932abeb7b516de930ba2705f/certifi-2025.1.31.tar.gz"
    sha256 "3d5da6925056f6f18f119200434a4780a94263f10d1c21d032a6f6b2baa20651"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/5b/8c/4f2f0784d08a383b5de3d3b1d65a6f204cc5dc487621c91c550388d756af/humanize-4.12.1.tar.gz"
    sha256 "1338ba97415c96556758a6e2f65977ed406dddf4620d4c6db9bbdfd07f0f1232"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/dd/8c/3a7ac7e1931bd1bca5f8e3687f7611083f6a79aae02b9cd6b7ce1fb4a8d0/inflate64-1.0.1.tar.gz"
    sha256 "3b1c83c22651b5942b35829df526e89602e494192bf021e0d7d0b600e76c429d"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "patch-ng" do
    url "https://files.pythonhosted.org/packages/ee/c0/53a2f017ac5b5397a7064c2654b73c3334ac8461315707cbede6c12199eb/patch-ng-1.18.1.tar.gz"
    sha256 "52fd46ee46f6c8667692682c1fd7134edc65a2d2d084ebec1d295a6087fc0291"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "py7zr" do
    url "https://files.pythonhosted.org/packages/26/c3/0e05c711c16af0b9c47f3f77323303b338b9a871ba020d95d2b8dd6605ae/py7zr-0.22.0.tar.gz"
    sha256 "c6c7aea5913535184003b73938490f9a4d8418598e533f9ca991d3b8e45a139e"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/bf/69/3f4ce9d4c79f6ddf6bf60af873f65605123a0e8cd13159f8531a9cb81710/pybcj-1.0.3.tar.gz"
    sha256 "b8873637f0be00ceaa372d0fb81693604b4bbc8decdb2b1ae5f9b84d196788d9"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/ba/d5/861a7daada160fcf6b0393fb741eeb0d0910b039ad7f0cd56c39afdd4a20/pycryptodomex-3.22.0.tar.gz"
    sha256 "a1da61bacc22f93a91cbe690e3eb2022a03ab4123690ab16c46abb693a9df63d"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/42/8e/06581a619ad31cd28fd897bd55aff2ea945d3d566969b8b3f682599e6dee/pyppmd-1.1.1.tar.gz"
    sha256 "f1a812f1e7628f4c26d05de340b91b72165d7b62778c27d322b82ce2e8ff00cb"
  end

  resource "pyzstd" do
    url "https://files.pythonhosted.org/packages/62/14/878fee4072cecb1cc6e061c7d0d933e481389c27de939538c9cc3f18894a/pyzstd-0.16.2.tar.gz"
    sha256 "179c1a2ea1565abf09c5f2fd72f9ce7c54b2764cf7369e05c0bfd8f1f67f63d2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "clang_64", shell_output("#{bin}/aqt list-qt mac desktop --arch 6.7.0")
    assert_match "linux_gcc_64", shell_output("#{bin}/aqt list-qt linux desktop --arch 6.7.0")
  end
end
