class Apicula < Formula
  include Language::Python::Virtualenv

  desc "Open source tools for Gowin FPGAs"
  homepage "https://github.com/YosysHQ/apicula"
  url "https://files.pythonhosted.org/packages/46/a8/c47790d71916fbf560dbf54c2df1f6acd8e992511e6c872cfbed171b7c91/apycula-0.35.tar.gz"
  sha256 "1fd15bdcf512eb8eedda48f11dc81fc35236a7ae904b1a887fd6ea44120f37c6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/YosysHQ/apicula.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "b783f701288b623569325fd398e29427b383ebc67f84c79704540afc4337d4a1"
    sha256 cellar: :any, arm64_golden_gate: "5d31d9502866027d8d84f9002df879597c0720f86f17c8ce59552dd789f7ad00"
    sha256 cellar: :any, arm64_tahoe:       "e8a643c8050bae955bb820807e1f0d19e362e4a1cfa6806c5e340e9cdb697b1c"
    sha256 cellar: :any, arm64_sequoia:     "647263dffbd9cf98afbea50514326147da2ff4b32a3961a70870e20aea388dd9"
    sha256 cellar: :any, arm64_linux:       "7be9ce332ae5cc6a0356cea3fae2cdb7a13ebe5ddc0217f72413a3abf95a1b7d"
    sha256 cellar: :any, x86_64_linux:      "75cc9f6f36ee0e6a0e2900cc1503ee9fe8b6571faf2606d9887006a77414104c"
  end

  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[numpy]

  resource "fastcrc" do
    url "https://files.pythonhosted.org/packages/58/bd/791d8656cd672cc2bc06fda83f5ce369ab5d3b8bf902ee270034d2cae4e8/fastcrc-0.5.0.tar.gz"
    sha256 "e02cdf379d7371f0bd9d7cac957c67f0696e62292d73eebe02ff6393eef05b50"
  end

  resource "msgspec" do
    url "https://files.pythonhosted.org/packages/d0/e6/6dcf9306ff3c5e486578f3bf29ed11dfbdbbc2a8bf0caf7e07d392887fda/msgspec-0.22.0.tar.gz"
    sha256 "0a13624a4969159fe35d8c2a3d377b2b61bbd8585e327440d5e52725affcce38"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gowin_pll", "--input-freq-mhz", "27", "--output-freq-mhz", "108",
                            "--module-name", "test_pll", "--filename", "pll.v"
    assert_match "module test_pll", (testpath/"pll.v").read
    assert_match "Achieved output frequency:    108.000 MHz", (testpath/"pll.v").read
  end
end
