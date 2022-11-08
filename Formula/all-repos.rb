class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/14/60/5f0d6f6193629929299422fbb87711983a764aa53820caf9ede7b0f4d389/all_repos-1.24.0.tar.gz"
  sha256 "a4e3dfdd8adebdbffbb659b06a516f6fa0967247cee87356911860e1302292df"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "730e5c63f68a2a074988b75c4c9b4fa9796980b698c53446aaf068f0e17f0cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "730e5c63f68a2a074988b75c4c9b4fa9796980b698c53446aaf068f0e17f0cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "b92e9d8aec632564a9281e563a853597fdde62485e9ad472de6523dcf455e5e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b92e9d8aec632564a9281e563a853597fdde62485e9ad472de6523dcf455e5e6"
    sha256 cellar: :any_skip_relocation, catalina:       "b92e9d8aec632564a9281e563a853597fdde62485e9ad472de6523dcf455e5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a71270cbde05dd6e5c60d11380223a33e8e5922d1a16ffb3ab503e151553b78"
  end

  depends_on "python@3.11"

  resource "contextlib-chdir" do
    url "https://files.pythonhosted.org/packages/f9/ac/1b3022cc91497b45a653e86fa91694a63684904388440d71e58ff531687b/contextlib-chdir-1.0.2.tar.gz"
    sha256 "58406a71db00647fcccfc7e52e9e04e44d29eacf30400e7c0ba3b15f09d5f3fa"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/67/e1/869d7b8df41a3ac2a3c74a2a4ba401df468044dccc489b8937aad40d148e/identify-2.5.8.tar.gz"
    sha256 "7a214a10313b9489a0d61467db2856ae8d0b8306fc923e03a9effa53d8aedc58"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
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
