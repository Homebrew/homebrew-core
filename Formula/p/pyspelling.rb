class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/12/07/168a857755a29b7e41550a28cd8f527025bc62fcb36a951d8f3f2eedcdf7/pyspelling-2.10.tar.gz"
  sha256 "acd67133c1b7cecd410e3d4489e61f2e4b1f0b6acf1ae6c48c240fbb21729c37"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "f364a5e63736d91e836130acd9578fd23178557d496b47a8085bc5ea68c9e556"
    sha256 cellar: :any,                 arm64_sonoma:  "a0b442e7373165dbfb8f25214b59a65f777b184297b119fab94e3e0ca6c86694"
    sha256 cellar: :any,                 arm64_ventura: "48009640d75f18f1846423c97fbd40f3380efea76eb8a62769e588ea222fe978"
    sha256 cellar: :any,                 sonoma:        "8ba1a7461c8dcb5b99bcc94b1ab9a3475ec188db46b6a96963c277175728413f"
    sha256 cellar: :any,                 ventura:       "de5ae39942a758e650b22e596f9e0a81107f7dc964cbfe0281428fca71537cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26c14629d1fd22e1d6b83af9b72891b1160f08d3fdcc28c9c4aa529e4910168a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd3f06b840816904dffb43f08a37efdf852255d22b6f4a393abe28319b5ea116"
  end

  depends_on "aspell" => :test
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/d6/6c/57418c4404cd22fe6275b8301ca2b46a8cdaa8157938017a9ae0b3edf363/bracex-2.5.post1.tar.gz"
    sha256 "12c50952415bfa773d2d9ccb8e79651b8cdb1f31a42f6091b804f6ba2b4a66b6"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/41/ab/b3a52228538ccb983653c446c1656eddf1d5303b9cb8b9aef6a91299f862/wcmatch-10.0.tar.gz"
    sha256 "e72f0de09bba6a04e0de70937b0cf06e55f36f37b3deb422dfaf854b867b840a"
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
    (testpath / ".pyspelling.yml").write <<~YAML
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
    YAML

    output = shell_output(bin/"pyspelling", 1)
    assert_match <<~EOS, output
      Misspelled words:
      <text> #{testpath}/text.txt
      --------------------------------------------------------------------------------
      favourite
      --------------------------------------------------------------------------------
    EOS
  end
end
