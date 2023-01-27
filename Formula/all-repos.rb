class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/14/60/5f0d6f6193629929299422fbb87711983a764aa53820caf9ede7b0f4d389/all_repos-1.24.0.tar.gz"
  sha256 "a4e3dfdd8adebdbffbb659b06a516f6fa0967247cee87356911860e1302292df"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "730e5c63f68a2a074988b75c4c9b4fa9796980b698c53446aaf068f0e17f0cdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "730e5c63f68a2a074988b75c4c9b4fa9796980b698c53446aaf068f0e17f0cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "730e5c63f68a2a074988b75c4c9b4fa9796980b698c53446aaf068f0e17f0cdc"
    sha256 cellar: :any_skip_relocation, ventura:        "b92e9d8aec632564a9281e563a853597fdde62485e9ad472de6523dcf455e5e6"
    sha256 cellar: :any_skip_relocation, monterey:       "b92e9d8aec632564a9281e563a853597fdde62485e9ad472de6523dcf455e5e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b92e9d8aec632564a9281e563a853597fdde62485e9ad472de6523dcf455e5e6"
    sha256 cellar: :any_skip_relocation, catalina:       "b92e9d8aec632564a9281e563a853597fdde62485e9ad472de6523dcf455e5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a71270cbde05dd6e5c60d11380223a33e8e5922d1a16ffb3ab503e151553b78"
  end

  depends_on "python@3.11"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/82/a9/3cf658d585698e8f14b09011018f4f3fd9d56b0eecefb79de89ec5cb6a92/identify-2.5.15.tar.gz"
    sha256 "c22aa206f47cc40486ecf585d27ad5f40adbfc494a3fa41dc3ed0499a23b123f"
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
