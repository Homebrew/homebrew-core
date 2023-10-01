class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/cc/49/789313a50b9cf1f46389f38d90549269472093ea4f21aff9269c5ff0a41c/pyspelling-2.9.tar.gz"
  sha256 "df74c42e6e24171b7e1a83ac62fa2e151028ac045817c4f0384791c2d6099c5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c6954deb1b6db7bada545e28e3dace4fc26fc3f4612f15ade5221709a35b3ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c9ab926a6bff7148400151417fd52a3e1b5b0e51fae0dd2bf9002c57654d49c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db2a098714e7fef3bf41ad38a231557a339fef54313c9f6a976e68feee94e53"
    sha256 cellar: :any_skip_relocation, ventura:        "6d3dd6fb3145cc2229f78bdf5739d096b3673a9c7b7deff6a242b9d7f704874c"
    sha256 cellar: :any_skip_relocation, monterey:       "70115b4c31e5865ebf0150786385f0588b2f205d8e2f5edb0f9680c4b4a6c36c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4caf2e4be74224347c1403d7e77111b3304967ea0a4c856231e7cf0e7c45f090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da695e5c25cc1bffb08d2a9f88ed0886da1b82577fa48efcc715532356ad871"
  end

  depends_on "aspell" => :test
  depends_on "python-lxml"
  depends_on "python-markdown"
  depends_on "python@3.11"
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
