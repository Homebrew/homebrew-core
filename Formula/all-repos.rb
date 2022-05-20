class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/40/19/5e40ad99a297ea1504ffba4dc1157f6c6f0212f450b230edde597bdbe199/all_repos-1.22.0.tar.gz"
  sha256 "cd65a4a409b367bb888245c1d8011295789691b4bed63ca79e650cfbed78c649"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c5171cf3b0754da46d3b7da9e216b84c08c70cfea6fab3f414e2347cce23a36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c5171cf3b0754da46d3b7da9e216b84c08c70cfea6fab3f414e2347cce23a36"
    sha256 cellar: :any_skip_relocation, monterey:       "ed2568f9c07408fd2e99791e96c5bcdc9cca58d77d58d9e9e218df55e11046f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed2568f9c07408fd2e99791e96c5bcdc9cca58d77d58d9e9e218df55e11046f1"
    sha256 cellar: :any_skip_relocation, catalina:       "ed2568f9c07408fd2e99791e96c5bcdc9cca58d77d58d9e9e218df55e11046f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60db1f33800d012e10246e7b09c6a34f71d58f606600ae5dfdd51fced6022334"
  end

  depends_on "python@3.10"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/67/0f/5f4c299e177a7738d56ba499380379889004a8830e25453967186d8157be/identify-2.4.12.tar.gz"
    sha256 "3f3244a559290e7d3deb9e9adc7b33594c1bc85a9dd82e0f1be519bf12a1ec17"
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
