class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/22/25/e42c9be788883c94ed3a2bbaf37c2351cfe0d82cdb96676a629ed3adedec/nvchecker-2.12.tar.gz"
  sha256 "4200ddf733448c52309f110c6fa916727a7400f444855afa8ffe7ff1e5b0b6c8"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47288b1fa808ce67e7b7fe0063784ed04add719e1387ab780191bce931a2aa21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1bffe2dc457ed6797fc8de6e6c116762e8b1013718f45dcc517da6c7f02d5c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "641aea8c3cb378d81b4ecb08317e20813d9ce1698ac3e54b712cc6dbd69744fd"
    sha256 cellar: :any_skip_relocation, ventura:        "7530ac266b3423319cd11f41681e0aff6ade71ab241e75c6ab04d7a13ca868bd"
    sha256 cellar: :any_skip_relocation, monterey:       "07f9f6e6255f1cfb8a75abbbd5b61e8f6895715e2d125ed57f8e3f790b057310"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a5dacaa160b2d7b9aeb242fe8e54d505780d9849d3ffd1ed92ef7d4aebeacc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "608784a3a5b015876a0480013b6e9de9a36c6ddb5eb829dbdeac1d52bdc25688"
  end

  depends_on "jq" => :test
  depends_on "python@3.11"

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a8/af/24d3acfa76b867dbd8f1166853c18eefc890fc5da03a48672b38ea77ddae/pycurl-7.45.2.tar.gz"
    sha256 "5730590be0271364a5bddd9e245c9cc0fb710c4cbacbdd95264a3122d23224ca"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
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
