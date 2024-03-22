class Auditwheel < Formula
  include Language::Python::Virtualenv

  desc "Auditing and relabeling cross-distribution Linux wheels"
  homepage "https://github.com/pypa/auditwheel"
  url "https://files.pythonhosted.org/packages/62/6c/0a99a7df52487bd2204a1b8ba56cd90f6f651d23027dc355e0e21b7b0492/auditwheel-6.0.0.tar.gz"
  sha256 "6422c4ab6421d23e355c91e9946926cd532b9fdf46f2b5ffdaf1abfe9ee29e67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e7935f976c5420a4d7a74ecc0a10b0fc8766bdc92756551cd16542e40a3a6cf"
  end

  depends_on :linux
  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/84/05/fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8/pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auditwheel -V")

    resource "homebrew-test-wheel" do
      url "https://files.pythonhosted.org/packages/4c/00/e17e2a8df0ff5aca2edd9eeebd93e095dd2515f2dd8d591d84a3233518f6/cffi-1.16.0-cp312-cp312-musllinux_1_1_x86_64.whl"
      sha256 "2d92b25dbf6cae33f65005baf472d2c245c050b1ce709cc4588cdcdd5495b520"
    end

    resource("homebrew-test-wheel").stage testpath

    output = shell_output("#{bin}/auditwheel show cffi-1.16.0-cp312-cp312-musllinux_1_1_x86_64.whl")
    assert_match "is consistent with\nthe following platform tag: \"linux_x86_64\"", output
  end
end
