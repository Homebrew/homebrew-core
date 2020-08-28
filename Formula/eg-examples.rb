class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/59/06/7281154a4cd961f56302d9cac300cc8fc965b16d04ce797ed622a2f53586/eg-1.2.0.tar.gz"
  sha256 "ac9827824c2c9aee0fd0a54ca57440021a0a87868b503b215c2c273a035bef59"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "66b8e36ffd66967947c4c31ac1c111210030bbb6072fa79a18f86ad75422b5d2" => :catalina
    sha256 "4384a8ac2ec7ea33981e29466989bfe56aec532635c2d1f1e079ee70b41d2a86" => :mojave
    sha256 "ea5150fcaec60e13589296f700b39aa7ee1b210f989bea1deee548fdeaf849b5" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
