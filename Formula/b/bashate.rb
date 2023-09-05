class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack/bashate"
  url "https://files.pythonhosted.org/packages/4d/0c/35b92b742cc9da7788db16cfafda2f38505e19045ae1ee204ec238ece93f/bashate-2.1.1.tar.gz"
  sha256 "4bab6e977f8305a720535f8f93f1fb42c521fcbc4a6c2b3d3d7671f42f221f4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0404cc095c3112a2393efa839c8ede16e4016a80f3e72767ca568d7956a685c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0404cc095c3112a2393efa839c8ede16e4016a80f3e72767ca568d7956a685c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0404cc095c3112a2393efa839c8ede16e4016a80f3e72767ca568d7956a685c4"
    sha256 cellar: :any_skip_relocation, ventura:        "92be21fb90d03ca6e332233b0128d97c512ec5299988fdaa2f1da61e2bf7fe98"
    sha256 cellar: :any_skip_relocation, monterey:       "92be21fb90d03ca6e332233b0128d97c512ec5299988fdaa2f1da61e2bf7fe98"
    sha256 cellar: :any_skip_relocation, big_sur:        "92be21fb90d03ca6e332233b0128d97c512ec5299988fdaa2f1da61e2bf7fe98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5969e7badb3d13d8392e1672235b959e0eed7f36545fd5ecf3a861cf4c8cfb80"
  end

  depends_on "python@3.11"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  def install
    ENV["PBR_VERSION"] = version.to_s
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
