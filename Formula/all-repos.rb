class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/9a/ea/cdabb519e8afc76df7d70b900403d4f118404c90665d4468c88101265c47/all_repos-1.26.0.tar.gz"
  sha256 "52fd543c17064af11c06cfe344bb43eda550f5a69de2be767d5c98661a0783b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c885454cdffad91c4e22d17c572cf087c276256dd9882f9f8a8276f3a313997"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7026fe7f4f1eb061dbd784cdeca98b64e9ee379a0f4de9f176b3f93dbf074c66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1908138a2250c88818cbaf31d7eab9827305ffb226026bdd071c4c6ae75573c7"
    sha256 cellar: :any_skip_relocation, ventura:        "f3bc9c09a83a469dc4c1a09d4ea7740fc7a66fbc2d1b33c6b786c47c0000cf38"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b5314f89edf61a719cadc2b216d5a7fdc4377a7da2862d3dc0ddd3cf733428"
    sha256 cellar: :any_skip_relocation, big_sur:        "64a6d424cc3c9eba0b6e902ff8e9424683ba8739512730c8ed8693c61f469478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bdc13e7f68446456b5b7a8aaea5756aac464637d03101336207cef6f704a0a0"
  end

  depends_on "python@3.11"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/c4/f8/498e13e408d25ee6ff04aa0acbf91ad8e9caae74be91720fc0e811e649b7/identify-2.5.24.tar.gz"
    sha256 "0aac67d5b4812498056d28a9a512a483f5085cc28640b02b258a59dac34301d4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
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
