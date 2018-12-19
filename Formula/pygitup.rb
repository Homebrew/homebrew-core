class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/46/45/32dc0bf07c620644a8ed899e381309f4f25b50f20a91e555285522592833/git-up-1.6.1.tar.gz"
  sha256 "ea83441e7ab05011624e2e7333ef875c263124db5eed74507acd32b07c48473f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ce722d6ce56c7f2409b8ec1fd41dad6ed105b16979ba0b1243d2ae363d6a179" => :mojave
    sha256 "f98f2a52e2d9d2a8dbbbea1c93608fd7bd215e3151fa95bb7435a1f808205fa5" => :high_sierra
    sha256 "50ed608db33595278f181af87c1c2a2ca1e8d7695434f9c71e6389db7ef53701" => :sierra
    sha256 "f75bf054577c1e9ecd6fa9489b0bf5f435e069eac979c650493b2f2550161913" => :el_capitan
  end

  depends_on "python"

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/84/11/22e68bd46fd545b17d0a0b200cf75c20e9e7b817726a69ad5f3070fd0d3c/gitdb2-2.0.3.tar.gz"
    sha256 "b60e29d4533e5e25bb50b7678bbc187c8f6bcff1344b4f293b2ba55c85795f09"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/f1/e4/2879ab718c80bc9261b34f214e27280f63437068582f8813ff2552373196/GitPython-2.1.10.tar.gz"
    sha256 "b60b045cf64a321e5b620debb49890099fa6c7be6dfb7fb249027e5d34227301"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/48/d8/25d9b4b875ab3c2400ec7794ceda8093b51101a9d784da608bf65ab5f5f5/smmap2-2.0.3.tar.gz"
    sha256 "c7530db63f15f09f8251094b22091298e82bf6c699a6b8344aaaef3f2e1276c3"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "git", "clone", "https://github.com/Homebrew/install.git"
    cd "install" do
      assert_match "Fetching origin", shell_output("#{bin}/git-up")
    end
  end
end
