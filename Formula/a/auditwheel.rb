class Auditwheel < Formula
  include Language::Python::Virtualenv

  desc "Auditing and relabeling cross-distribution Linux wheels"
  homepage "https://github.com/pypa/auditwheel"
  url "https://files.pythonhosted.org/packages/7b/ed/342df5a75589103d72402dcdd88d7b8cc2df338fbc39042ce1b3ac008960/auditwheel-6.6.0.tar.gz"
  sha256 "277f3b315ad0b04df0a2be2d126c3fd39930bc265df0f9589d78c970ff06f52b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55ab9c5eceea9c8b091e8f9522f260544e886a1473fe1ee655cfd1c06ba4decf"
  end

  depends_on :linux
  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/b9/ab/33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071af/pyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
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
