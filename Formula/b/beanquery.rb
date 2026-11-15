class Beanquery < Formula
  include Language::Python::Virtualenv

  desc "Customizable lightweight SQL query tool"
  homepage "https://github.com/beancount/beanquery"
  url "https://files.pythonhosted.org/packages/7c/90/801eec23a07072dcf8df061cb6f27be6045e08c12a90b287e872ce0a12d3/beanquery-0.2.0.tar.gz"
  sha256 "2d72b50a39003435c7fed183666572b8ea878b9860499d0f196b38469384cd2c"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc5cb548f518d07830368db0034c8d4688b46f3d6feb4d56e024dfd2394b2b9c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1696997edb1352415a9147ca591bf3664fe9d679867bcee6aaeca1fcd93cc664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b973c462f3942b3f7bb0847e79a13f9fbe443cd15b9c06d2fd7f22c97dc95fd"
    sha256 cellar: :any,                 arm64_linux:       "282b2c0d7ed2ad02e96226b1a326633f56afcbb52e7f43fe341e2209c083914a"
    sha256 cellar: :any,                 x86_64_linux:      "2ef3d81d6cd9e3639f8c4e64f61bc5b30225d43a4c6d84fe234282d91e67576d"
  end

  depends_on "bison" => :build # for beancount
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.15"

  uses_from_macos "flex" => :build # for beancount

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/eb/21/ed48e671a5e474c620762a7ea9c6b7f402f847d74dd2b73ceb5d2dec79a3/beancount-3.2.3.tar.gz"
    sha256 "f52c4d237bcb092cbf02a29373d3e59d95349c2828a91491818ae437ee220f74"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tatsu-lts" do
    url "https://files.pythonhosted.org/packages/d3/81/9ab714191017d23a0e73921e7d869890e5bf6a5eca89dee57d2b76c6c536/tatsu_lts-5.16.0.tar.gz"
    sha256 "40ad376b4ed4e139a8d00d00bd6659d44c3b7546933fb3314132f776bfa1f44f"
  end

  def install
    venv = virtualenv_install_with_resources(without: "beancount")

    resource("beancount").stage do
      inreplace "pyproject.toml", /^\s*'(flex|bison)-bin.*\n/, ""
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"bean-query", shell_parameter_format: :click)
  end

  test do
    (testpath/"test.beancount").write <<~EOS
      option "title" "Beanquery Test"
      2025-01-01 open Assets:Cash
      2025-01-02 * "Test Transaction"
        Assets:Cash          -10.00 USD
        Expenses:Test        10.00 USD
    EOS

    output = shell_output("#{bin}/bean-query test.beancount 'select account, sum(position)' --no-errors")

    assert_match "Assets:Cash", output
    assert_match "Expenses:Test", output
  end
end
