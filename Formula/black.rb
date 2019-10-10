class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/89/07/aebb10fb8f2ffbac672dfbebffa724643bc84cf012a57737a622d1dabddb/black-19.3b0.tar.gz"
  sha256 "68950ffd4d9169716bcb8719a56c07a2f4485354fec061cdd5910aa07369731c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4866fe54e66a07a307f7c7a4f00f13a1efa2802271e6b84cad3b080b65131cd2" => :catalina
    sha256 "ef695bcdffed96f3c28c7ea0fe5ea51a18a1ad2c152fc25ba02871ba950b94b9" => :mojave
    sha256 "f3e89b08d42080b08ebf3cd2ffecfac53f4c56f7dc7ce55f722a6425954f642a" => :high_sierra
    sha256 "ecf9478d385e1756118ba799463970e517582f19399ea8f51fb36ccb66f344d4" => :sierra
  end

  depends_on "python"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/cc/d9/931a24cc5394f19383fbbe3e1147a0291276afa43a0dc3ed0d6cd9fda813/attrs-19.1.0.tar.gz"
    sha256 "f0b870f674851ecbfbbbd364d6b5cbdff9dcedbc7f3f5e18a6891057f21fe399"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/b9/19/5cbd78eac8b1783671c40e34bb0fa83133a06d340a38b55c645076d40094/toml-0.10.0.tar.gz"
    sha256 "229f81c57791a41d65e399fc06bf0848bab550a9dfd5ed66df18ce5f05e73d5c"
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
