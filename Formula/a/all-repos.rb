class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/8c/49/3676bb22d86cf623b7590e10c5751e8f936054ccc639ce8c50e0ccbb4644/all_repos-1.28.0.tar.gz"
  sha256 "c459fd941439a77e6dad4ad39f8b29fd02ef3bb176b4b56cf211412e4e9e79bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01e9dc189f6669330605fd87047895cf026fe91fc4b481fc2ba494739370658f"
  end

  depends_on "python@3.13"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/1a/5f/05f0d167be94585d502b4adf8c7af31f1dc0b1c7e14f9938a88fdbbcf4a7/identify-2.6.3.tar.gz"
    sha256 "62f5dae9b5fef52c84cc188514e9ea4f3f636b1d8799ab5ebc475471f9e47a02"
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
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
