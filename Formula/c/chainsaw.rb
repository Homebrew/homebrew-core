class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.9.1-2.tar.gz"
  sha256 "55625660f21ef11ebd7f95c4d4746f8c5c5616db92670d508fc947a52b744e24"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb69f1712241bef2da1d82f7cb15ec1da219fb6f355d13442964d4100a1d51f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d08843f16c3a7c791429b2492657e28a89beef2dcb35847522815f36ee24114"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2348f7399e4a02182596e835822fa5f6ae8634a96dea01f9de641bc6b4c3774"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0a2b54617f019aea804d502aff2d01ffd49d00b5a47f2d4362498b5f53e368d"
    sha256 cellar: :any_skip_relocation, ventura:        "13b0d05670f63ccad5ba0099c22cfe7e03a8d62497e69738c52e0ee9e27264e7"
    sha256 cellar: :any_skip_relocation, monterey:       "a87a17022eb6772c01bb96a7fe9745ed16eaece2529df9d36ad4e3f600b865a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c19eaf295b48958e68f2806a13250a3bf696ce666d057d3bccf4c5348a1558e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end
