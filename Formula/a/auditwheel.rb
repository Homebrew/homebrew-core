class Auditwheel < Formula
  include Language::Python::Virtualenv

  desc "Auditing and relabeling cross-distribution Linux wheels"
  homepage "https://github.com/pypa/auditwheel"
  url "https://files.pythonhosted.org/packages/4d/52/83393c50a4d497e6d2f62ddf0b439bf3a5eecd4e6b8ae43c219cb722224e/auditwheel-6.8.2.tar.gz"
  sha256 "d007c4fd8c9c4b5113690ab0b159e05c5aa9b2d31b69efc40875826cc095594b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65da5fbaead988dfbcc6e68330356ab7ccdee99d3d8cf6960cf03932a836a7f8"
  end

  depends_on :linux
  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/a3/11/767522582afab1b884d277de0e6e011640cb9d7292a38694b4b1a1df1ae8/pyelftools-0.33.tar.gz"
    sha256 "660d82dcbeb8e83d1702bd97f223f761625da06111c0cc988eac6b8ab0c1b61f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auditwheel -V")

    if Hardware::CPU.intel?
      resource "homebrew-test-wheel" do
        url "https://files.pythonhosted.org/packages/f1/47/d7145bf2dc04684935d57d67dff9d6d795b2ba2796806bb109864be3a151/cffi-1.17.1-cp313-cp313-musllinux_1_1_x86_64.whl"
        sha256 "72e72408cad3d5419375fc87d289076ee319835bdfa2caad331e377589aebba9"
      end
      platform_tag = "musllinux_1_2_x86_64"
      wheel_file = "cffi-1.17.1-cp313-cp313-musllinux_1_1_x86_64.whl"
    else
      resource "homebrew-test-wheel" do
        url "https://files.pythonhosted.org/packages/5f/e4/fb8b3dd8dc0e98edf1135ff067ae070bb32ef9d509d6cb0f538cd6f7483f/cffi-1.17.1-cp313-cp313-musllinux_1_1_aarch64.whl"
        sha256 "3edc8d958eb099c634dace3c7e16560ae474aa3803a5df240542b305d14e14ed"
      end
      platform_tag = "musllinux_1_2_aarch64"
      wheel_file = "cffi-1.17.1-cp313-cp313-musllinux_1_1_aarch64.whl"
    end

    resource("homebrew-test-wheel").stage testpath

    output = shell_output("#{bin}/auditwheel show #{wheel_file}")
    assert_match "is consistent with\nthe following platform tag: \"#{platform_tag}\"", output
  end
end
