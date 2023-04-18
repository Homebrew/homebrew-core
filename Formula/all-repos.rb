class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/00/54/c9f28df541c717bbe1e1920ddb99a4a52c6a2accd69ce56602632b2f03c3/all_repos-1.25.0.tar.gz"
  sha256 "06fdef4b4d0984c79b1887e012e8c90e03ddea0273ac692d4127ba44c6b34d99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "180abab58ecc446d8045449cd0a601dd48ec223cfba9289b5d931e7273cd000a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c678f94a52097856b6799ed8dd4c87e28dc52ad0a221c3a5c73f4cee009a5c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4682db5be5c8e6afbff8650bddf5ba4a2c4c65246267fcf789194184e3f6567"
    sha256 cellar: :any_skip_relocation, ventura:        "72beee3ac81491cf4a819ff64c697ef0f55184df892f0a8b8b9a474736afa507"
    sha256 cellar: :any_skip_relocation, monterey:       "e03dfac164b84ce9c2295d2a5005ff96e90c2efbbf6ef1bd86252212a1e47d94"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cfed750da5b85bd9fc56206f1edfdab3d79801f6c688dedeed5330b5aaa032f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7572ac9c563d044496856824043ff5f1d9eda0038cb98398fee7aad9a882a11"
  end

  depends_on "python@3.11"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/6b/c1/dcb61490b9324dd6c4b071835ce89840536a636512100e300e67e27ab447/identify-2.5.17.tar.gz"
    sha256 "93cc61a861052de9d4c541a7acb7e3dcc9c11b398a2144f6e52ae5285f5f4f06"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~EOS
      {"discussions": "https://github.com/Homebrew/discussions"}
    EOS

    system "all-repos-clone"
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
