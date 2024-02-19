class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/51/f2/e34dd8cdf4ca4918dc4bc6f11021ed5f6aacef9ff22db1191577ed85ab3e/hy-0.28.0.tar.gz"
  sha256 "ae202f0b5e9094489af2a41b2cee9e0f776d0572da69cb108db2935a7224e17a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5f265d4db441fb9c3c21f3cd09c6774a2d47cdce3b458242665549e7e0f981d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051ccb3d93bf866cc6f57a577b5bd9075849f770468eb9ef4c1d391023fe29da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8674dc76a1ee9bb08754372e00b41d7084ae1e25ba2185f0633de809400b0b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfcf0c7a6c0ae82297994412816125054d2a4c5c083d7c27ab2c3e3200253f6f"
    sha256 cellar: :any_skip_relocation, ventura:        "35783286f088eab5dc036cf13ae75782339c909c7c6c7c47ac4aa272478e6f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "4c2a9ffc3f4e43428ae4b3baad55d45e3c3316e3505ba469860159d929158287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "863743f916eda9c288a61b22316b6d60335b50b1dd9c4b9b0376bce7eda7b40b"
  end

  depends_on "python@3.12"

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/93/44/a21dfd9c45ad6909257e5186378a4fedaf41406824ce1ec06bc2a6c168e7/funcparserlib-1.0.1.tar.gz"
    sha256 "a2c4a0d7942f7a0e7635c369d921066c8d4cae7f8b5bf7914466bec3c69837f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    python3 = "python3.12"
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")
    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{python3} test.py")
  end
end
