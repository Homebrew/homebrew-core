class Bed < Formula
  desc "Binary editor written in Go"
  homepage "https://github.com/itchyny/bed"
  url "https://github.com/itchyny/bed/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "c163cc9d851db280e85adc2d5218ffad9a39c79f6f874c0d9dfaff939b6cd9ca"
  license "MIT"
  head "https://github.com/itchyny/bed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfb34b60ab80a48e3300c99ab2ea194764333621361faab095e118b1c6878ea2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfb34b60ab80a48e3300c99ab2ea194764333621361faab095e118b1c6878ea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfb34b60ab80a48e3300c99ab2ea194764333621361faab095e118b1c6878ea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e6b457c5eb0e9ca5d98c7811ceeeccd896a58235b9d171568ad4d4afc555bac"
    sha256 cellar: :any,                 x86_64_linux:      "ab42b10999e83ad3520fe631866beace1b5814543e216d251c7aa0659732352f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.revision=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bed"
  end

  test do
    # bed is a TUI application
    assert_match version.to_s, shell_output("#{bin}/bed -version")
  end
end
