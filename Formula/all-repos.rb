class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/5c/d6/283af98bbb784dc235c5bcd6ac0dedfc178bcc1116cb20b89c49ed895bf1/all_repos-1.21.2.tar.gz"
  sha256 "2c42f1cb18aebc2efa601d76fbbadee98a4dc6d71a73b1f29ef9155d191f966b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf2dd0dbee7019d6970e3f035c35f94655c0c325852d05a565d6b851d13fd0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bf2dd0dbee7019d6970e3f035c35f94655c0c325852d05a565d6b851d13fd0a"
    sha256 cellar: :any_skip_relocation, monterey:       "20eb6b107e120de3a52867fd18476cfd47bf19744729da8480eeee716c02daf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "20eb6b107e120de3a52867fd18476cfd47bf19744729da8480eeee716c02daf1"
    sha256 cellar: :any_skip_relocation, catalina:       "20eb6b107e120de3a52867fd18476cfd47bf19744729da8480eeee716c02daf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67bac0403a7614ae391bbde4457743f473f2f9abdff420909b17117683d782cb"
  end

  depends_on "python@3.10"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/e7/2c/3f6822048d64c62df153b26bb91d8d3a7e8fbd08ee57f9d55dd6a2d3548a/identify-2.3.1.tar.gz"
    sha256 "8a92c56893e9a4ce951f09a50489986615e3eba7b4c60610e0b25f93ca4487ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": ".",
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
    assert_predicate testpath/"discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "./discussions:README.md", output
  end
end
