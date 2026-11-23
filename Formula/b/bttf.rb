class Bttf < Formula
  desc "CLI tool for datetime arithmetic, parsing, formatting and more"
  homepage "https://github.com/BurntSushi/bttf"
  url "https://github.com/BurntSushi/bttf/archive/refs/tags/0.2.0.tar.gz"
  sha256 "5399df79e15ba48e94526319ec6baf4e4e9bbe983693adc4ba784294f0875e78"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/bttf.git", branch: "master"

  bottle do
    manifest_sha256 "732f41771cacfc151122d6efb7288581cdede6652580f1bd60e3a87edb268a83"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0a716a01dfbc34568de419c0625b3afc49e95cef0e6c4d4d5568e30b538cc2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a58425fc68d7c600d54761bc454cccac37a32ba829c48c8b756b31000ed50376"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11bce6db2ed04ea1a44710a4c663ffadd3242c4273fc2bd7f412413d6e39ae78"
    sha256 cellar: :any,                 arm64_linux:       "79a74c56b37bb14ad872fa1ad65030201bfee7ee88dc3f19146f9b1af940fca4"
    sha256 cellar: :any,                 x86_64_linux:      "06d9803e4818fc7df2316685ad1ff7daa6033f8a331704f4035674c597370054"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bttf --version")
    assert_equal "2026-06-11\n", shell_output("#{bin}/bttf time fmt -f '%F' 2026-06-11")
  end
end
