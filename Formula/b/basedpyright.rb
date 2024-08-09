class Basedpyright < Formula
  include Language::Python::Virtualenv

  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://files.pythonhosted.org/packages/19/26/f79e1e1311d1d0742141b5bee44ca0891b4624ecd33f3f0ae8ef68625e84/basedpyright-1.15.2.tar.gz"
  sha256 "c07f4ad7d5b2a2d3194ecdfa311b7a58da8670144873ff54f0d2d40a5d1b5944"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "python@3.12"

  resource "nodejs-wheel-binaries" do
    url "https://files.pythonhosted.org/packages/36/7a/9c3e424382eda040b01f344b7a64b11d2e4decc2c6d381f7ca68751603f8/nodejs_wheel_binaries-20.16.0.tar.gz"
    sha256 "85649da01bb3d0d3c9237d28545180254cda5417b4e2c219f53face0103fb2bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/basedpyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end
