class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://static.crates.io/crates/kalker/kalker-2.2.3.crate"
  sha256 "b61611a29ed9fe8f1889439d531d39bbb10d96b82756c89e77d4808fd541cd91"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05f2c2e0ff63be5e6fe533ff70307a78e790a7dee0f762f3518c9b87dc31d2ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4773ce70ff3b360a0a077a3998e466dcc8d1ae993a62bea335dcf16d857a4b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "930aba26c13acd165e86fb81edfa147d4395be2047318ca43c4c374c295b22e7"
    sha256 cellar: :any,                 arm64_linux:       "17b5da7eb083afe1c08b4c72a9fb19121296bcd717d27e887d845c3464c54647"
    sha256 cellar: :any,                 x86_64_linux:      "f6f0b0f8ea12c09d0b1d7a484f6729fa1361c7cca225a3bb8769c2dd3acbdc75"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalker -h")
    assert_equal "= 15", shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp
  end
end
