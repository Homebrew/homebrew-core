class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/ad/07/04237f8cac359478740c6217c844764845ecfe061bf8ba7479da15d6dc55/pyspelling-2.14.tar.gz"
  sha256 "d1bb3eaca2cf45e33aa2dc6ca2cc1927b9f9b5f5449d75b043c6c16d1bdec613"
  license "MIT"

  bottle do
    manifest_sha256 "7a5981dd114a41924d13f046970aa869e68f6051d4d725608926b5b903c085cc"
    sha256 cellar: :any, arm64_golden_gate: "47b7aade53b43333ab7d5bd31732b39cbb0ea88d2bbcdd75c442235453bc2fbf"
    sha256 cellar: :any, arm64_tahoe:       "e905187dfebde25212e400473c49b7ba2701b27ced48e39d8f8a19f583226ec1"
    sha256 cellar: :any, arm64_sequoia:     "cb2979ad13e920d68b1942f99635c8dea073d3bd49497fe44fc834355ecd6cdd"
    sha256 cellar: :any, arm64_linux:       "ed159cd5243b87239eb6b1b0e3247367df68392f23d626a5c6d53d75c86d5438"
    sha256 cellar: :any, x86_64_linux:      "ddd9b06f99708d1864b346ea7b382e09a6d3585b996a7eeac49d1925d1ad5723"
  end

  depends_on "aspell" => :test
  depends_on "libyaml"
  depends_on "python@3.15"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/66/6f/95a6fcb1c430007cda4122c77aace4541fba297f08e2be791ab235a4c548/bracex-3.2.4.tar.gz"
    sha256 "c1e67eb59f81445dee15b2c588b7c81352b697cfbd6c4931a2943ea6b71eb5ea"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/589"
    end
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/ca/eb/dc0fd6eff604bfb870b7fb68b90985a32caaf3c76f67736bbf7f438acd59/markdown-3.11.3.tar.gz"
    sha256 "81eb91631dc97ad1efbc76019ef0f80fe90ca49ddf81546752d79989c3bfff3e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/82/77/d59ca6aa338bdd8d880234d15b7c466cb176e44502899a9df81ba2e13cd0/soupsieve-4.1.3.tar.gz"
    sha256 "13f70186c8f40bf8d0ff7bbab09a18fb149600b465269207b5e5b588f55fda08"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/96/3a/fd5e95b2c1c04e3874682f9796d06f7389e2a95ab581177800ca17e785fa/wcmatch-12.0.4.tar.gz"
    sha256 "23fe77fbfa3fff9e46f0f4a3d1891065270596774bd6131bd2f973fb822242a1"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  def install
    # Workaround for https://github.com/html5lib/html5lib-python/issues/593
    odie "Check if setuptools workaround can be removed!" if resource("html5lib").version > "1.1.0"
    (buildpath/"build-constraints.txt").write "setuptools<82\n"
    ENV["PIP_BUILD_CONSTRAINT"] = buildpath/"build-constraints.txt"

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
        - text.txt
    YAML

    output = shell_output(bin/"pyspelling", 1)
    assert_match <<~EOS, output
      Misspelled words:
      <text> text.txt
      --------------------------------------------------------------------------------
      favourite
      --------------------------------------------------------------------------------
    EOS
  end
end
