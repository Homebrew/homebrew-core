class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/12/07/168a857755a29b7e41550a28cd8f527025bc62fcb36a951d8f3f2eedcdf7/pyspelling-2.10.tar.gz"
  sha256 "acd67133c1b7cecd410e3d4489e61f2e4b1f0b6acf1ae6c48c240fbb21729c37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c2eca55d8f8a0772a62fb884d8af589c29b01dbe59f713c24e52f01608aa197"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1a27b892d485d6ae39458ff7a6251078299958e2497740e38f923e860eb3f9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4346f191c20659dd54498144b4bd6884bb8ad67ca65570688982aaa24b43d1c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a1450ce0589d80ce769f974824897a411393549ed716400e1d94c23c3dc3e1b"
    sha256 cellar: :any_skip_relocation, ventura:        "0522d090091cc4b4d68d9e85050f715126261766651766a9577883e2f4fa6294"
    sha256 cellar: :any_skip_relocation, monterey:       "22bacc42b4763bb153993f71b338ad385543ce6908f3d66f46ff1176e68044c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee6699d2fa97f4cae9f9f97c2289027ab3fe9a00ce09a84d5b7216a22b81e84"
  end

  depends_on "aspell" => :test
  depends_on "python-lxml"
  depends_on "python-markdown"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/92/51/72ce10501dbfe508808fd6a637d0a35d1b723a5e8c470f3d6e9458a4f415/wcmatch-8.5.tar.gz"
    sha256 "86c17572d0f75cbf3bcb1a18f3bf2f9e72b39a9c08c9b4a74e991e1882a8efb3"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath / "text.txt").write("Homebrew is my favourite package manager!")
    (testpath / "en-custom.txt").write("homebrew")
    (testpath / ".pyspelling.yml").write <<~EOS
      spellchecker: aspell
      matrix:
      - name: Python Source
        aspell:
          lang: en
          d: en_US
        dictionary:
          wordlists:
          - #{testpath}/en-custom.txt
        sources:
        - #{testpath}/text.txt
    EOS

    output = shell_output("#{bin}/pyspelling", 1)
    assert_match <<~EOS, output
      Misspelled words:
      <text> #{testpath}/text.txt
      --------------------------------------------------------------------------------
      favourite
      --------------------------------------------------------------------------------
    EOS
  end
end
