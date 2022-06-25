class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/68/bb/8f852a2a9591d53c083384f6cd95d9e857b2802668f922fa0b50468a280b/hy-0.24.0.tar.gz"
  sha256 "de3928ff7f97893bb825e59f17f3cd19e4b59beecb71c38039b8f349ca8dfe1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f15f27bd30f78a786f2eeba4003709c8a3ca3804447e8459ae9f19e06cb383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98b24099b57bdb1322de0e0a20885853a3cc6ddeeb21b833293c3372a600f005"
    sha256 cellar: :any_skip_relocation, monterey:       "4ffdb327dcea3f6e0701efcb105170080503ec1fc001d4fb1ea5c0052dcd57ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a8611e5647203bc52944ae8c3a7fb1c105e1dda9d65a6641fef45edfc1f48c"
    sha256 cellar: :any_skip_relocation, catalina:       "b8f9062329e87549cc63f63712e0a5790d9722905fd15765d82f997296f49c58"
    sha256 cellar: :any_skip_relocation, mojave:         "30734f23d8c216671a4eb3b8595288354e8f00f31da0da76f9022595c3daf496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e161e87fe9e19ee309ddfceb1cfb56f9d16394cff58b402b920f75e0ef0bc6"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/53/6b/02fcfd2e46261684dcd696acec85ef6c244b73cd31c2a5f2008fbfb434e7/funcparserlib-1.0.0.tar.gz"
    sha256 "7dd33dd4299fc55cbdbf4b9fdfb3abc54d3b5ed0c694b83fb38e9e3e8ac38b6b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")
    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{Formula["python@3.10"].bin}/python3 test.py")
  end
end
