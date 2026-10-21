class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https://iredis.xbin.io/"
  url "https://files.pythonhosted.org/packages/24/3c/9d26458a7e1a064f417fbdca8e9c0656c3c1a0afda225bf6ad76c3ff4f70/iredis-1.16.1.tar.gz"
  sha256 "862a67a59e05710cb6547bdff55e3b6801298578f78d39e7fa953424f68793df"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/laixintao/iredis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c4366197db847ee9a7fbdafb2698b1b8fdf7fa7efd4c0516e366c6c56064ac2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd03bc863fc3b7931e1ad5618687058c9011f082f4f9226f2b2412953b1f3530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a66351c27f3f6880dbd3406aac7379da9fcd62da7d56071fc62358f53add3b2"
    sha256 cellar: :any,                 arm64_linux:       "c60197cbf8779249f6bf926af9ec72b5f908ac9cddbf96a01dfa066b48596005"
    sha256 cellar: :any,                 x86_64_linux:      "cc1357d52a299b485028ef5b938f46b441f776f4516439fe4f642388b4002761"
  end

  depends_on "python@3.15"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/7b/92/328a294a6de83bacb95bed01f04e0eaff4e3616ee359fc821a5dfc539b02/mistune-3.3.4.tar.gz"
    sha256 "58b5c96d6fcb61190dfe5fae498d2b2065f99cf61e9649418fd54cf1ada86dfe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/51/93/05e7d4a65285066a74f48697f9b9cde5cfce71398033d69ed83c3d98f5c9/redis-7.4.1.tar.gz"
    sha256 "1a1df5067062cf7cbe677994e391f8ee0840f499d370f1a71266e0dd3aa9308e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"iredis", shell_parameter_format: :click)
  end

  test do
    port = free_port
    output = shell_output("#{bin}/iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end
