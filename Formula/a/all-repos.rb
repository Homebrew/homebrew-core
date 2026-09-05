class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/e2/ce/2b87583b0b56193c868eb246c6765660467f241d1c4d16e5e1229bac7dfd/all_repos-1.33.0.tar.gz"
  sha256 "420ee23a9ad825914700e511ba51b88780b1c69d24aa88506a2b2e6e8bc0eb20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b040ed36823087349983193c7130015d6e552e2c908be0717ee6b33d78c6148c"
  end

  depends_on "python@3.14"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/52/63/51723b5f116cc04b061cb6f5a561790abf249d25931d515cd375e063e0f4/identify-2.6.19.tar.gz"
    sha256 "6be5020c38fcb07da56c53733538a3081ea5aa70d36a156f83044bfbf9173842"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
