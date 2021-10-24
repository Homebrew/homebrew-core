class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/5c/d6/283af98bbb784dc235c5bcd6ac0dedfc178bcc1116cb20b89c49ed895bf1/all_repos-1.21.2.tar.gz"
  sha256 "2c42f1cb18aebc2efa601d76fbbadee98a4dc6d71a73b1f29ef9155d191f966b"
  license "MIT"

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
