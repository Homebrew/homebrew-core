class AdrViewer < Formula
  include Language::Python::Virtualenv

  desc "Generate easy-to-read web pages for your Architecture Decision Records"
  homepage "https://github.com/mrwilson/adr-viewer"
  url "https://files.pythonhosted.org/packages/1b/72/0f787da38d0f9d69c06b31d8f412735ed4fad383edd7f7d2286f4fc7b5b0/adr_viewer-1.4.0.tar.gz"
  sha256 "9a2f02a9feb3a6d03d055dd8599b20d34126f8e755b4b4ee1a353ecbbd590cef"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b12cb08799dcf6fb78b0bf55eb9601f6ddb14be34a69422e74f9c4377b6e6c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5ebeb6ec7d5ef62ce1fbd71fd64e5cae43c0308200fb6607b67da929df7d452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2c1f99a51f6e897fd58f048c90df94a1ce1cf03a6c6e61cc5fb15710b67602"
    sha256 cellar: :any_skip_relocation, sonoma:        "48cfd793dcde485c4e19cdc8ca5488ea30282829ec888f9dd83fdf562ab84e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "410d4f2c715a9d2a1afe0522ecd8b249c2c8a607a86d2f946051fe6d5aba1923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b267fa080e8d5b1750951fa2ae1b18c11687fa2af57dd9a5bc7032d2e71bdc69"
  end

  depends_on "python@3.14"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7a/71/cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454/bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/ca/84/620cc3f7e3adf6f5067e10f4dbae71295d8f9e16d5d3f9ef97c40f2f592c/mistune-3.2.1.tar.gz"
    sha256 "7c8e5501d38bac1582e067e46c8343f17d57ea1aaa735823f3aba1fd59c88a28"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"adr-viewer", shell_parameter_format: :click)
  end

  test do
    adr_dir = testpath/"doc/adr"
    mkdir_p adr_dir
    (adr_dir/"0001-record.md").write <<~MARKDOWN
      # 1. Record architecture decisions
      Date: 2018-09-02
      ## Status
      Accepted
      ## Context
      We need to record the architectural decisions made on this project.
      ## Decision
      We will use Architecture Decision Records, as [described by Michael Nygard](https://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).
      ## Consequences
      See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https://github.com/npryce/adr-tools).
    MARKDOWN
    system bin/"adr-viewer", "--adr-path", adr_dir, "--output", "index.html"
    assert_path_exists testpath/"index.html"
  end
end
