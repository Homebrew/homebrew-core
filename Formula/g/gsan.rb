class Gsan < Formula
  include Language::Python::Virtualenv

  desc "Extract subdomains from SSL certificates in HTTPS sites"
  homepage "https://franccesco.github.io/getaltname/"
  url "https://files.pythonhosted.org/packages/73/0c/1fc5a29ae79fd74f0fd54d2c4d487b8cf7b21ede08efe99a6c39977816c6/gsan-5.0.0.tar.gz"
  sha256 "2418a6897b0eb1c6eb44c3521ccc5c69a811071f864b8001fd9699a4d2f4c9e3"
  license "MIT"
  revision 5
  head "https://github.com/franccesco/getaltname.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "893b6887104e2783dd4b4fa44feb0d12a01cdf2f2913ce4d3c9b0c3b8cd44342"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "python@3.15"

  # Remove `pyasn1` and `pyopenssl` once the patch is no longer required.
  pypi_packages exclude_packages: %w[cryptography pyasn1 pyopenssl]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
  end

  # Extract certificate SANs via `cryptography` instead of pyOpenSSL's `X509.get_extension`,
  # which was removed in pyOpenSSL 26 but we require this for cryptography compatibility.
  patch do
    url "https://github.com/franccesco/getaltname/commit/e68f61d418a3ce4e55797fe4ae175e65d73c8cb5.patch?full_index=1"
    sha256 "64691b483f9e12050052218c6f8db07787eea18e9141973de5b47fc9282557bc"
    type :unofficial
    resolves "https://github.com/franccesco/getaltname/pull/37"
  end

  def install
    # Turn on shell completions option
    inreplace "src/gsan/main.py", "add_completion=False", "add_completion=True"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"gsan", shell_parameter_format: :typer)
  end

  test do
    assert_match(/google.com \[\d+\]/, shell_output("#{bin}/gsan google.com"))
  end
end
