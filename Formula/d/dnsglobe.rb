class Dnsglobe < Formula
  desc "Global DNS propagation checker TUI"
  homepage "https://github.com/514-labs/dnsglobe"
  url "https://github.com/514-labs/dnsglobe/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "6bbcf1204abeb556bc502956f37c4b43ae0e1400ae1ce4550fabd215eca05b69"
  license "MIT"
  head "https://github.com/514-labs/dnsglobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51105646fca308e35e70e56adaa169865bcdc142e94b2e963376f45c62439f86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554bfbd15feba3e77f87eeec867ed71df9520ce8210ce4e8c9bba8b389004131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "038039689e424d4bdf547416f078ed8441695494d6ee4d77c2a00f3f9b9a6329"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6136acdedcb414ecab19e81d61a7fcbb220e344091ecbabfbb8ce7f5525c77a"
    sha256 cellar: :any,                 arm64_linux:   "f815808b0ec521fde57d3648b9aa545e5e16b4fb00f3c109264aa53af3ade66f"
    sha256 cellar: :any,                 x86_64_linux:  "59fd4cbfa357c4a80a7506abfb3c2200a3dad4caf506d28f38d492cdc5d75d1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsglobe --version")

    output = shell_output("#{bin}/dnsglobe --once brew.sh")
    assert_match(%r{propagation \(\d+/\d+ responding\)}, output)
  end
end
