class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/67/94/7975a04dd17c815b45f5f75fa07a49770b5f230320672dea155ea0a3ca14/pyspelling-2.11.tar.gz"
  sha256 "94cc6efa979c26779601ad666f8d986adf52d247b313337ad67aac7163749d0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18ddb16f81f214a25157456570ca04f67efff77f64cd7d9d6ec8048a7109d39b"
    sha256 cellar: :any,                 arm64_sequoia: "56b569bbf6a38dc26c47df5325212468f75ddb5f5809672948294db126273c2a"
    sha256 cellar: :any,                 arm64_sonoma:  "7524282f70b1fedadcb636fad65d98b8c5813a353c754e505eb0c9764dea7d4e"
    sha256 cellar: :any,                 arm64_ventura: "776eda5513b84fbe395300fb59541abc0643ef5e631042f9deacfd76d0d85c11"
    sha256 cellar: :any,                 sonoma:        "d6ca132d25a2d953ee71f58f5d92b70d994d49590187559a0c580d581dbf502c"
    sha256 cellar: :any,                 ventura:       "df3a9d8e993ddfe610b55150104856c4ddb8b71564669fc96b98c182c9fffb65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b514fcb5374cbaf19ca7870558d2b566368d44aba02d676ae66076a4959bfdd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e453cb9ab623206b1ef428c7f939c1b1ec8af6a50e30ed0717980754a3b0bcf"
  end

  depends_on "aspell" => :test
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/85/2e/3e5079847e653b1f6dc647aa24549d68c6addb4c595cc0d902d1b19308ad/beautifulsoup4-4.13.5.tar.gz"
    sha256 "5e70131382930e7c3de33450a2f54a63d5e4b19386eab43a5b34d594268f3695"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/d7/c2/4ab49206c17f75cb08d6311171f2d65798988db4360c4d1485bd0eedd67c/markdown-3.8.2.tar.gz"
    sha256 "247b9a70dd12e27f67431ce62523e675b866d254f900c4fe75ce3dda62237c45"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/79/3e/c0bdc27cf06f4e47680bd5803a07cb3dfd17de84cde92dd217dcb9e05253/wcmatch-10.1.tar.gz"
    sha256 "f11f94208c8c8484a16f4f48638a85d771d9513f4ab3f37595978801cb9465af"
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
