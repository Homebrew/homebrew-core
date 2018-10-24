class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/e8/5f/0f79fcd943ba465cbd4bf303c9794970c13a95e5456630de9f72e7f37ad4/black-18.9b0.tar.gz"
  sha256 "e030a9a28f542debc08acceb273f228ac422798e5215ba2a791a6ddeaaca22a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcb14738c971f7701f6b1911d9988cd62411ffbdc004ff5b1a0988fe92a2d993" => :mojave
    sha256 "1991045f7a79c0321947b6fed7ac9d2d69bf548863dc07b202e90c401ee42a73" => :high_sierra
    sha256 "495f31fe2eea2f0b1e104f2c7eee96694bda0a1a0ef1029b33565293e4f5cecf" => :sierra
  end

  depends_on "python"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e4/ac/a04671e118b57bee87dabca1e0f2d3bda816b7a551036012d0ca24190e71/attrs-18.1.0.tar.gz"
    sha256 "e0d0eb91441a3b53dab4d9b743eafc1ac44476296a2053b6ca3af0b139faf87b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/f5/f9/044110c267e6408013b85166a7cfcd352cf85275aa8ce700aa5c0eb407ba/toml-0.9.4.tar.gz"
    sha256 "8e86bd6ce8cc11b9620cb637466453d94f5d57ad86f17e98a98d1f73e3baab2d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"black_test.py").write <<~EOS
      print(
      'It works!')
    EOS
    system bin/"black", "black_test.py"
    assert_equal "print(\"It works!\")\n", (testpath/"black_test.py").read
  end
end
