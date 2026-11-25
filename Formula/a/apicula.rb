class Apicula < Formula
  include Language::Python::Virtualenv

  desc "Open source tools for Gowin FPGAs"
  homepage "https://github.com/YosysHQ/apicula"
  url "https://files.pythonhosted.org/packages/0f/26/c4193044b39ad2c2282279273e642547776adcf6d11830e2fa4fe8028b78/apycula-0.36.tar.gz"
  sha256 "19b0d9dc62d09cb9af2e6e9f8cd034da5a4c2e3b63296da89b91eec08fd1ab3f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/YosysHQ/apicula.git", branch: "master"

  bottle do
    manifest_sha256 "199233766ceaba87c779c7b7600d7705cb1912758fec5b1c72209b702c000597"
    sha256 cellar: :any, arm64_golden_gate: "a9ad842211467451b270e5c4ea59ed4b5aecac39464032d1dd1d05c351443ed1"
    sha256 cellar: :any, arm64_tahoe:       "8041612970a882b15507555025210e4b8cbc7acece92e4de07961e36f2d2a6c1"
    sha256 cellar: :any, arm64_sequoia:     "23036891b16e1b6442c02b0555232cd26b7a0ca0d5abc45b3046e3b22afb0632"
    sha256 cellar: :any, arm64_linux:       "83684e7ed6026c65c49b818e66f8ddbde4aba2268399514713ef70ed0422279d"
    sha256 cellar: :any, x86_64_linux:      "1905deb5e10fc98e9e8e00b7142a232a14decd869138d2e0574084f94bf54b29"
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
