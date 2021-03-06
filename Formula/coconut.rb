class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/3a/85/7697306188fc03809e794a65a2a745fdde052065b83571bdc36de7fe5a77/coconut-1.5.0.tar.gz"
  sha256 "cb2263fb9e1aa4c6bb7e3051ae26e1444297ecc5e8762c4f8547873b6a0d861d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ebbb005b2c3a3848f5593718d8a21a98adade56ef4bb4239fe553a60fc3f9a17"
    sha256 cellar: :any_skip_relocation, big_sur:       "987bf18d2f7bb2378ae95c21e2a2ede148c02086099c661081040a3b69b6a0d3"
    sha256 cellar: :any_skip_relocation, catalina:      "4a4707189427a591dde0fd1897af8c31e64e350fbc8598bd2d929aa6df726cc9"
    sha256 cellar: :any_skip_relocation, mojave:        "088c30ab276e9a04cf3ea31a65f96ca532d6f3870d55673cc0784fe83aaa6652"
    sha256 cellar: :any_skip_relocation, high_sierra:   "97e617049fd9e250dfd0c3353441595fb1d4a8bacd6a0ec73eefb15fe2a0e63c"
  end

  depends_on "python@3.9"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/7e/08/00b11cc1c195301e5c9710b399a769e18fb6c7f8082b4f49c1aec78023eb/cPyparsing-2.4.5.0.1.2.tar.gz"
    sha256 "689b6d53f85bef876fdb07829393bbbed66d2fada176a9386800dc49e4251b46"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b1/32/2a6b734dc25b249467bfc1d844b077a252ea393d1b90733f4e899aa56506/prompt_toolkit-3.0.16.tar.gz"
    sha256 "0fa02fa80363844a4ab4b8d6891f62dd0645ba672723130423ca4037b80c1974"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/19/d0/dec5604a275b19b0ebd2b9c43730ce39549c8cd8602043eaf40c541a7256/Pygments-2.8.0.tar.gz"
    sha256 "37a13ba168a02ac54cc5891a42b1caec333e59b66addb7fa633ea8a6d73445c0"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
