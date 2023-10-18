class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack/bashate"
  url "https://files.pythonhosted.org/packages/4d/0c/35b92b742cc9da7788db16cfafda2f38505e19045ae1ee204ec238ece93f/bashate-2.1.1.tar.gz"
  sha256 "4bab6e977f8305a720535f8f93f1fb42c521fcbc4a6c2b3d3d7671f42f221f4c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d22a13965b8badc19e991a9a271e9f1975f85b96d68dbc22d25cf196f42b4ae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0137ed279d4f0f319d8c50eb4d86e20b25f7bfbe4c07d45fb455fde83516acd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e886d384c41e915700b72256b7cf60e0d33743958eb8bd960544d15918ebede8"
    sha256 cellar: :any_skip_relocation, sonoma:         "58523165172e73d1b4658e6beb217ad0ce1aecba52185f6b6cd7f7fd3736d75a"
    sha256 cellar: :any_skip_relocation, ventura:        "f4ff5795ad844e2bd2235e0528b04551fad9264616cd072dba0f806de9c15c2d"
    sha256 cellar: :any_skip_relocation, monterey:       "314b0d6247591b2812a710cdc133e2fbdce772fb723e44e7dd893a7d08bf0394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104403b5c06e8bdb94a82195bbba24462d62cee9717b2a3c29a3da75707f968d"
  end

  depends_on "python@3.12"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
        echo "Testing Bashate"
    EOS
    assert_match "E003 Indent not multiple of 4", shell_output(bin/"bashate #{testpath}/test.sh", 1)
    assert_empty shell_output(bin/"bashate -i E003 #{testpath}/test.sh")

    assert_match version.to_s, shell_output(bin/"bashate --version")
  end
end
