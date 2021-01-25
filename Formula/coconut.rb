class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/49/bd/c77663bf5525bcb3c0995ebe0257cc5a9ef6d191cdb354faccc9841afe99/coconut-1.4.3.tar.gz"
  sha256 "5053e876388faaa792154d3e86c27dcfa721d48a3611a8d9b94e7567e5652c0b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "987bf18d2f7bb2378ae95c21e2a2ede148c02086099c661081040a3b69b6a0d3" => :big_sur
    sha256 "ebbb005b2c3a3848f5593718d8a21a98adade56ef4bb4239fe553a60fc3f9a17" => :arm64_big_sur
    sha256 "4a4707189427a591dde0fd1897af8c31e64e350fbc8598bd2d929aa6df726cc9" => :catalina
    sha256 "088c30ab276e9a04cf3ea31a65f96ca532d6f3870d55673cc0784fe83aaa6652" => :mojave
    sha256 "97e617049fd9e250dfd0c3353441595fb1d4a8bacd6a0ec73eefb15fe2a0e63c" => :high_sierra
  end

  depends_on "python@3.9"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/f4/2e/11f7fd3dd699c57d27890971e104b632c7f6c4f96a9e58cd062473b39922/cPyparsing-2.4.5.0.1.1.tar.gz"
    sha256 "9ef74514ca2359e3458674f1a0ee53632eb3c873361f766c5b90a7eed34699cd"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/69/19/3aa4bf17e1cbbdfe934eb3d5b394ae9a0a7fb23594a2ff27e0fdaf8b4c59/prompt_toolkit-3.0.5.tar.gz"
    sha256 "563d1a4140b63ff9dd587bda9557cffb2fe73650205ab6f4383092fb882e7dc8"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
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
