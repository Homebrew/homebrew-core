class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "caa2bd8072e71f6871e7e93bd3072684f48fbebd85e1de0c48b86b143034ee98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "534535d47f2fbaecee8c68a36d91ec274b1ff72ee645443e91ffb37868433f24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b94a8f5f78e803c25ecd6c1f465642d426fb19fb7b9d5e4fcc91bdcc42c18c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f6dcd8bbf7a594cebae917697c2b2cdad3b36e5c4335fc7db7139c8fb4ab08f"
    sha256 cellar: :any,                 arm64_linux:       "aee4e95cbc9965e2d365d0da6ebc1e89e14b65e1fd466845040a6635abefee52"
    sha256 cellar: :any,                 x86_64_linux:      "04117018a32b97b4b1bdf262c972519b2654cc3a3ec312940d3273a2008fdf04"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "hawkeye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hawkeye --version")

    configfile = testpath/"licenserc.toml"
    configfile.write <<~TOML
      includes = ["licenserc.toml"]
    TOML

    assert_match "unknown field `includes`", shell_output("#{bin}/hawkeye format 2>&1", 2)
  end
end
