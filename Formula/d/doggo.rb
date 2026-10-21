class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d707bd7948cd560c290298ba623f70681e93862eed2c8555b09b7b90f5610c9c"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da2488fe0a57630864d2ca293ad51b23e32ef10265d3fa15ccfff64ff049ce5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da2488fe0a57630864d2ca293ad51b23e32ef10265d3fa15ccfff64ff049ce5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da2488fe0a57630864d2ca293ad51b23e32ef10265d3fa15ccfff64ff049ce5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "737e06bd645154492cf6c47cf8e0e53c32690ac4de6e6ec12076964201692f43"
    sha256 cellar: :any,                 x86_64_linux:      "7d5ff47ed47454368a74cd170f034f9dc456a403ddaeb1bb2a4a8da5e56222e6"
  end

  depends_on "go" => :build

  # `test do` block performs DNS lookups
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
