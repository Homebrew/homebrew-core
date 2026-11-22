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
    manifest_sha256 "0243d1187b213ad6d406052f6ce9497ed689699299e3bfd7ce879d7eb8073658"
    sha256 cellar: :any, arm64_golden_gate: "bbf2b4721f0f144186651217ba2835b37f511fe04dd52acca03adb621953a6d6"
    sha256 cellar: :any, arm64_tahoe:       "3f1081a68e8e31079f6339920fa398fd41f7402cbc9cc406da6679f5cdf210c7"
    sha256 cellar: :any, arm64_sequoia:     "17b13c6123bb6073c8752974e6800ffc8e1a47db79459e538b769112f266c483"
    sha256 cellar: :any, arm64_linux:       "ca9a61c62e7112524391528e5d62615388151d150f80ee0280120a6b29c129b0"
    sha256 cellar: :any, x86_64_linux:      "012c79330ff8dc68a01bd17b6103befff0202176faf281367cd07db699442996"
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
