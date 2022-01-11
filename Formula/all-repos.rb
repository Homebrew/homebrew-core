class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/7b/fa/519428f5e2f272a57f7fd450cc437b3ab1539663afb512c8e1f2444e1a59/all_repos-1.21.3.tar.gz"
  sha256 "65e914237cc779cc2a5179204ebec943dfccae480b30fb5db6f4e22d87548861"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56fd86708254d95178a85b47f0ce195cb565ba8e40d03840c5be382a17453db8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56fd86708254d95178a85b47f0ce195cb565ba8e40d03840c5be382a17453db8"
    sha256 cellar: :any_skip_relocation, monterey:       "ce5a4bb6f07c52d8cbdb5ef109750c598445b3f9ae37a9ee2357cd9da01b9d99"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce5a4bb6f07c52d8cbdb5ef109750c598445b3f9ae37a9ee2357cd9da01b9d99"
    sha256 cellar: :any_skip_relocation, catalina:       "ce5a4bb6f07c52d8cbdb5ef109750c598445b3f9ae37a9ee2357cd9da01b9d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60618cbd84a252c728655da405fd83d40139dd697b79f41996425cac5a704232"
  end

  depends_on "python@3.10"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/3f/b7/931c3dbe30b5a03db56689a97d38b0692289369b32ea353a9265d318a32f/identify-2.4.1.tar.gz"
    sha256 "64d4885e539f505dd8ffb5e93c142a1db45480452b1594cacd3e91dca9a984e9"
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
