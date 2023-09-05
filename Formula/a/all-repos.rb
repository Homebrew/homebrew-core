class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/9a/ea/cdabb519e8afc76df7d70b900403d4f118404c90665d4468c88101265c47/all_repos-1.26.0.tar.gz"
  sha256 "52fd543c17064af11c06cfe344bb43eda550f5a69de2be767d5c98661a0783b2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "318d4219f21145a182e2294b816d298b0419e0a2b0176159179c823ad678d163"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27547640d5d301b30d26130881651cbeb9c5fe6c4c7342c5d2696abbc47226ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08fac20bbc7fd16204d95ee32bbb336bcb5250909aca17c65b654e56df19725d"
    sha256 cellar: :any_skip_relocation, ventura:        "438f205fd3e970a6870269d7c85afc70cd0bcf9a295bd1ed93179bcc0f179f44"
    sha256 cellar: :any_skip_relocation, monterey:       "7059a579c9f46b781c24b9b4eb9b9fe28a32fb6e18b99b1af858369d0d545ce1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fefb9da82cc389c71b159ecfecab896ea95490c713794b0e7982b8239c7bd4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f49ea61cb1733449a24d5518037c0d16d7b8f84d396e5d8f704722aad0b62c31"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/c4/f8/498e13e408d25ee6ff04aa0acbf91ad8e9caae74be91720fc0e811e649b7/identify-2.5.24.tar.gz"
    sha256 "0aac67d5b4812498056d28a9a512a483f5085cc28640b02b258a59dac34301d4"
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

    system bin/"all-repos-clone"
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
