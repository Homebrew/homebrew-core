class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/e6/16/9c4a52a5274d6b0e0526aeab9e6a562583f46feb941093842849b44717c4/all_repos-1.29.0.tar.gz"
  sha256 "5b85bd259819f5e7d1dd6a06f0f4730d1ea822b95f496edcdbafd328110547f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "670a510cc3937a676372a13afaf9764a568152cad4f6466f308261c7f89dc508"
  end

  depends_on "python@3.13"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/82/bf/c68c46601bacd4c6fb4dd751a42b6e7087240eaabc6487f2ef7a48e0e8fc/identify-2.6.6.tar.gz"
    sha256 "7bec12768ed44ea4761efb47806f0a41f86e7c0a5fdf5950d4648c90eca7e251"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~JSON
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    JSON
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~JSON
      {"discussions": "https://github.com/Homebrew/discussions"}
    JSON

    system bin/"all-repos-clone"
    assert_path_exists testpath/"out/discussions"
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
