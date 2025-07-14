class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/4a/bd/b23682af89619bf74844e3394de6d92f870b28e9d68747c7940f45fe079b/all_repos-1.30.0.tar.gz"
  sha256 "4407ca18c5d63428ec3d1af21a36527e999f04dffcd36cbfbd8e8c1d6792ec1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "682d934409fcf01972765afc9625c67329d5e13ce52f3970a8fb11beaa627503"
  end

  depends_on "python@3.13"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/a2/88/d193a27416618628a5eea64e3223acd800b40749a96ffb322a9b55a49ed1/identify-2.6.12.tar.gz"
    sha256 "d8de45749f1efb108badef65ee8386f0f7bb19a7f26185f74de6367bffbaf0e6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
