class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "3d7a60c4b5cdb6bbe8f33a5cb45761ae0e1d1d008bf73cd7a1ea50f1ea2955b8"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "973023b5d20e006aac52862a3376153305a62b2b45719d52a6520adeebaea5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e08d8747b556d120682a3bbd0848fbc2e4a60389e6d3527f5aaa10e88727b00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297f9b9da2a2cdfdd9165150189efc65c3e8ea91eea6359550a356d0b062cf32"
    sha256 cellar: :any_skip_relocation, sonoma:         "5599eb6ca5d69d4ecef899fa62555b60653d7a2434f39c3a3009e736cdc582b3"
    sha256 cellar: :any_skip_relocation, ventura:        "60e38ace488c571d1318f7bf7e47e7b5c254ce2985d6c4ebbdbdfe8e8cd24529"
    sha256 cellar: :any_skip_relocation, monterey:       "a05b1d076291199064c5147b2d1706b04ae838f3df19801b42b2c45af52bae36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3c3239ae156fc3ee1ad6b4041d61f65462eafa61f6d2c53d7b74384a5d656c"
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
