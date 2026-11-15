class Asnmap < Formula
  desc "Quickly map organization network ranges using ASN information"
  homepage "https://github.com/projectdiscovery/asnmap"
  url "https://github.com/projectdiscovery/asnmap/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f4c615392cf206930361588a03b3df8f46775faabf37b84a398068dbe7159008"
  license "MIT"
  head "https://github.com/projectdiscovery/asnmap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6b2bd38faa8f0da00cbb343edcbda98e4c7f884eeb776dedf337418ea18a840"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e53399ddacff111529151d6cb08937ae8c45fada3bcd69fadd6b9cdacf71d3c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c38f58ab963ca734c3148079225a6bfa73ca6adc721cf1ba8c2cc528623a16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c607f263a752f19ba7d634be951ae986441cc841129404dd38e860fd4e49b64"
    sha256 cellar: :any,                 x86_64_linux:      "d179bf79692bbcd03c9abd3046559507449d7d407e314172668bef7eb41d497f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/asnmap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asnmap -version 2>&1")

    # Skip linux CI test as test not working there
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # need API key for IP lookup test, thus just run empty binary test
    assert_match "no input defined", shell_output("#{bin}/asnmap 2>&1", 1)
  end
end
