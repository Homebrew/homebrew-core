class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/2d/43/64205493cfb4c8e1720208d73502a121ace2a195cd4d1d49bd7470e4fd92/black-18.6b4.tar.gz"
  sha256 "22158b89c1a6b4eb333a1e65e791a3f8b998cf3b11ae094adb2570f31f769a44"

  bottle do
    cellar :any_skip_relocation
    sha256 "759cb37625946fd94f5c8adb9134b4d96f6e93c4d8503eb47cf18e948d4a1281" => :high_sierra
    sha256 "72eec6847ef869a472ee07ace9a4a5d90a570fc37f8c87b59c6d3ee267eb42b6" => :sierra
    sha256 "ab475a413e817787eea8d7119fdbb34463ab210d08249574e3a863f2bd3a0c5b" => :el_capitan
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
