class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "5478dd880f98abe4fdf13e7c38289aaa98b25e063ba40e8b9e69b22e2dc64ce7"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "bc918f8e7061f0bab690e470e81dc525c2d40b400b850847ef8a29969472d51b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3582ed3de6504b8c3c77878761ffc2fcf81cac7c4e2db8c4767674a0dca14906"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "894e0dec12bfe5fd8f69e630e3eb0540d5e3f35ae23cc5731b81d10c9669212d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63370d88f77df893070c6a1637aaf42d24452da22768013c58af2bc750ed26a0"
    sha256 cellar: :any,                 arm64_linux:       "4ddaeca1db11f9320b14cedc8c7a7bbd7d4f2c984b422f8737574786031ab0df"
    sha256 cellar: :any,                 x86_64_linux:      "756ffd9ae4d58d96abc75b4ceaafa036836fee2ec050ff09b8caebc0844ade51"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", pipe_output("#{bin}/jaq '.a'", '{"a": 1, "b": 2}', 0)
    assert_match "2.5", pipe_output("#{bin}/jaq -s 'add / length'", "1 2 3 4", 0)
  end
end
