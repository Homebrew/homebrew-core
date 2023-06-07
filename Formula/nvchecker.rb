class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/02/08/ee78cbb49fcbafbf566546439368a87466763a698f1483aeb93c0f4bdda2/nvchecker-2.11.tar.gz"
  sha256 "80d22af6bcdfa08a336b086eca98cef863ae21ca8a4822e2577075e2bca6cf00"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11f75cb4dd19c70b0fab6132699aa22434fdff267adc4268010eb68b3fdb66c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd9d350de940c8a994c560dc2907e3afbe367fcc0388a7a2eb76aa419ac5248c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e10b48d2ca164bbf9012947243ec9d447405f73048d957efb5a42dbbb099a451"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9daa9ea8f57aed84d2ff3ddcc5146eae0b607aef79472936d20da31af1aa4e"
    sha256 cellar: :any_skip_relocation, monterey:       "a9039dd3342213e20e77366daa077ce7c189d68026d90d746d66e79b811eb89a"
    sha256 cellar: :any_skip_relocation, big_sur:        "257bb52f7313182d35e3fccf90adaa87e5f2f1d32d9298920e4d2320c34bb1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13512ed0223eda2b0e515d9be897bb09053a3ab28f8e4659f542a6ca1f0e1223"
  end

  depends_on "jq" => :test
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9c/0e/ae9ef1049d4b5697e79250c4b2e72796e4152228e67733389868229c92bb/platformdirs-3.5.1.tar.gz"
    sha256 "412dae91f52a6f84830f39a8078cecd0e866cb72294a5c66808e74d5e88d251f"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a8/af/24d3acfa76b867dbd8f1166853c18eefc890fc5da03a48672b38ea77ddae/pycurl-7.45.2.tar.gz"
    sha256 "5730590be0271364a5bddd9e245c9cc0fb710c4cbacbdd95264a3122d23224ca"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/30/f0/6e5d85d422a26fd696a1f2613ab8119495c1ebb8f49e29f428d15daf79cc/tornado-6.3.2.tar.gz"
    sha256 "4b927c4f19b71e627b13f3db2324e4ae660527143f9e1f2e2fb404f3a187e2ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
