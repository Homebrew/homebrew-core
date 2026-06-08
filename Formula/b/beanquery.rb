class Beanquery < Formula
  include Language::Python::Virtualenv

  desc "Customizable lightweight SQL query tool"
  homepage "https://github.com/beancount/beanquery"
  url "https://files.pythonhosted.org/packages/7c/90/801eec23a07072dcf8df061cb6f27be6045e08c12a90b287e872ce0a12d3/beanquery-0.2.0.tar.gz"
  sha256 "2d72b50a39003435c7fed183666572b8ea878b9860499d0f196b38469384cd2c"
  license "GPL-2.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0ea637446c2d7eb8930e746b3be679eeae47b1076caf5058db7663c8a58af38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca536f7312cd6167419431e34d58244102d1cdc5baa9423932b3d32bc54b60f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45ef625aee5f37785cebbaa263bfe2dd164bdea24048c0b18692f4dedc3e8fc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "40dd1c6d699b8e9ec7ffe963810b8dfe632d6ec400ff2a194f6f2e757af73ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39e9789b913f6c9cab4d48316faa39cf02c2f4ac679516039dde84136c7d66e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed19884643dbf00f34a7ed9765324a7d04d84adf58432bce9281b27629e57290"
  end

  depends_on "bison" => :build # for beancount
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14"

  uses_from_macos "flex" => :build # for beancount

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/57/e3/951015ad2e72917611e1a45c5fe9a33b4e2e202923d91455a9727aff441b/beancount-3.2.0.tar.gz"
    sha256 "9f374bdcbae63328d8a0cf6d539490f81caa647f2d1cc92c9fa6117a9eb092ca"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tatsu-lts" do
    url "https://files.pythonhosted.org/packages/62/55/8123c70881c58d0f01f48d869378717a101149491dd8e13cd908eb06a5a4/tatsu_lts-5.13.2.tar.gz"
    sha256 "7204dbc3075fabecedd1ec1cbe04c5f20b159d7344f63280e580a21f3c14bf9f"
  end

  def install
    virtualenv_install_with_resources

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
