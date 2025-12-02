class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/81/6d/2e793a3884244034e2a4e587759ddda0a94f808571a01d6acb15cb3702c8/all_repos-1.31.0.tar.gz"
  sha256 "b9083857addd96b76ae958b25ac19ad314f3e5c43e3212721b943fc7f14ea851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d814d6697713609b2396d80fc04f27b0cadff970894c236b6c0fd73c6e8de8ca"
  end

  depends_on "python@3.14"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/ff/e7/685de97986c916a6d93b3876139e00eef26ad5bbbd61925d670ae8013449/identify-2.6.15.tar.gz"
    sha256 "e4f4864b96c6557ef2a1e1c951771838f4edc9df3a72ec7118b338801b11c7bf"
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
