class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "1f1af67b7b4f91743abb48b06a68f65cb1ca4d546f95a7d259a963c2e8b32511"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28611127c024dd6b50511ae221227e80cdf52987bf6481d9200775030e553628"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28611127c024dd6b50511ae221227e80cdf52987bf6481d9200775030e553628"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28611127c024dd6b50511ae221227e80cdf52987bf6481d9200775030e553628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "28611127c024dd6b50511ae221227e80cdf52987bf6481d9200775030e553628"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a507cb18ba43ae70b2e0b27b8cfa1e01aec45833e4c989db1344e18cc1ac5f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fffd385d250b5fe0c2cf12295453fb39dc470a617955cb321fa96ab9cb70032d"
  end

  depends_on "go" => :build
  depends_on "jj"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
