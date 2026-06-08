class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/a2/64/c2dcf990cd2644d0f871cee3434779569d210897b0860e749b9b4a0c6def/all_repos-1.32.0.tar.gz"
  sha256 "b57b70f20a2f9f92a9462089d432d41625b10936d311b3c300260d781607886d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9cccdeefabe4b8761ca38ab654c85030fac831d5335984d16cbd9ee93c98c088"
  end

  depends_on "python@3.14"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/52/63/51723b5f116cc04b061cb6f5a561790abf249d25931d515cd375e063e0f4/identify-2.6.19.tar.gz"
    sha256 "6be5020c38fcb07da56c53733538a3081ea5aa70d36a156f83044bfbf9173842"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
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
