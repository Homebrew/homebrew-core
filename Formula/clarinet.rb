class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/v0.14.2.tar.gz"
  sha256 "a3335960bd7c2529b7a11744205030ce849ccaa539f34da57d13c1fff1379d38"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08ecf876acbdc24bc33660bdd8843ff052539ae2c3e0ec52f4eb81ec067ae589"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9b7178b4f219f4c64d8f154ad320d74f19a543ac91a3b4d0a4c1012a19dd74e"
    sha256 cellar: :any_skip_relocation, catalina:      "40b66cb01751c17a517b640bd15251f2f56f2124b77e4c40e699459e6e71a191"
    sha256 cellar: :any_skip_relocation, mojave:        "899590f8a38475a7aea5c82de8b3e680157ab24c1adf4adc1643ac7f1d45312d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
