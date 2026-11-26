class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "fb5c5f88f347591152d342fab85870596acdbe620da61ee55dc486771c6811a7"
  license "MIT"

  bottle do
    manifest_sha256 "267250aafbd26003db98754ea0fdb0dbf6256043e5b198ba33e682aba421e5b0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4efb55a7f9a31c2deafa26f217557bef27c885ca10d2b10904c535eb7bfb8a6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6bf9ce730281ebc2e0ad95ee5475204e3f36a652bf95939411dc98caeafcf54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a2f975e1ac5548495a84a4f66577d753a6d435a2389d556cee73ce69398e57d"
    sha256 cellar: :any,                 arm64_linux:       "b12c829788a0d378e8cc0ec7755bccbcc848e8a1b76fe791c4e78a857995ecbf"
    sha256 cellar: :any,                 x86_64_linux:      "7572754fcb1548415a69aad51c5d59c59ab806d8147b17f0e35d8381fb9f52c5"
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
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
