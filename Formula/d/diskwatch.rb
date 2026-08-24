class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e595d7e70d729221b00709502c429d0a6b7cebc4d7b37be320c659605254f51d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5634491cd07e0cb3fc83c9e3fa6265862c30fb056acbced6253e9b5203ab799"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dd611c04c9a3046fb90eca65da9f1d712f4775a4d801926cf69b95ae35aaf81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0884fc1e7d69aa0d7781214f0e54c05fa3be58b57fbc8eb3920ad7bc10f60873"
    sha256 cellar: :any_skip_relocation, sonoma:        "0df6fec7adbbac70082e256768b00b84dc31d09310b734146df8d0551ad07837"
    sha256 cellar: :any,                 arm64_linux:   "00cde1811e4de7790e2378da445da2e6e09af1aac07b999d86230987539ef805"
    sha256 cellar: :any,                 x86_64_linux:  "09dec368ae5bd7db0e5e494a8649e9a134b8eec91f764ae9f8dc7bad1f9bf642"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
