class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/a6/56/29006be2546b897a5c62a3d4a7e613abf5a3533554d948b0e0af27546f1b/all_repos-1.27.0.tar.gz"
  sha256 "96fea3e34caa004b0770501e6efb93dc49cbca05fb56c2b8b2a85d06fb3a4573"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "01ac796e20537a0c9eae3a55935cba36e2048b80fe3d93ced82759b3ac4aae34"
  end

  depends_on "python@3.13"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/29/bb/25024dbcc93516c492b75919e76f389bac754a3e4248682fba32b250c880/identify-2.6.1.tar.gz"
    sha256 "91478c5fb7c3aac5ff7bf9b4344f803843dc586832d5f110d672b19aa1984c98"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
