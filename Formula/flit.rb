class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/takluyver/flit"
  url "https://files.pythonhosted.org/packages/85/d7/88c66e3d9ce4097cb37e25161b338dc1d1683fbd9ce7771523b5ee6cd77b/flit-3.7.0.tar.gz"
  sha256 "73545a1067799c606432f7d8ab3200f0bd6e0ad8a5df7b34ed65822352bf29ee"
  license "BSD-3-Clause"
  head "https://github.com/takluyver/flit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4828a471659f21a14528b04701000efc3040832f6e0e918fd25abbe09cca2bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c6e251db39739f7b5a0eea54a0faaf84f7f0b7f4120a421199959931030bcb"
    sha256 cellar: :any_skip_relocation, monterey:       "1e0424b2252cf569188d5b9d3d2646ed49467773963019e3576b12137a03e810"
    sha256 cellar: :any_skip_relocation, big_sur:        "a62ed5023739077a149c90386a29e9c2462af4fa20ecc22557921e05d406cd97"
    sha256 cellar: :any_skip_relocation, catalina:       "1078b0dea734de9fc34f7c258e617b250f1cadcd928e1c4fed335bf01512a82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a39c8bc6dffa87a7ab0c839ad2a2844091ef4eec1f97b7a4d6c499077b219ece"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "flit_core" do
    url "https://files.pythonhosted.org/packages/12/c8/ce203079be7deab7b4cdc1aaf20c95e15c584daec712cb55807e2ef1c7f1/flit_core-3.7.0.tar.gz"
    sha256 "c2aa7757bb3e056ecf741427fb8f1f759a180d7235a8c5f9b4aa929f3dd4e327"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.py").write <<~END
      """A sample package"""
      __version__ = "0.1"
    END
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    END
    system bin/"flit", "build"
    assert_predicate testpath/"dist/sample-0.1-py2.py3-none-any.whl", :exist?
    assert_predicate testpath/"dist/sample-0.1.tar.gz", :exist?
  end
end
