class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.14.tar.gz"
  sha256 "7d740f0569b7e3e3c42b928b102b2235f57e83687bdd5bd331043e96486c65c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cb4d5934217d039eb233d4e3bf4799f25b9ba79bb37b14b26299a508b61a8c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6055881d1e0689aa480545ea086650007986268c104245d09f215f44937594c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "879988aec88eb2e29a65c6cf06ef3c64aff46b06c5317a96562fee25a037046c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21667fcb1f6b730ab6d5cd822488005cc6678d23754b0bf28987cc024f600ed1"
    sha256 cellar: :any,                 arm64_linux:   "645d6dd3a8c08aeeade768c2fda5b26d1d7708c1fc89bf87f653d5680fab1e95"
    sha256 cellar: :any,                 x86_64_linux:  "988cf103e6b3c2d7fabfb1ea9fa33e32d9194782593d1ccdfd59c2c1ceb26a48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
