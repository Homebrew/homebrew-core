class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.12.tar.gz"
  sha256 "736692b7ee62ba7a4f368868f690bdccca62bcfaf7f6b79acd9e364b75055dc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3ab09d4b481472f183986a08af83cfddf8b75a4c85606d27880dbf72e62899b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3ab09d4b481472f183986a08af83cfddf8b75a4c85606d27880dbf72e62899b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3ab09d4b481472f183986a08af83cfddf8b75a4c85606d27880dbf72e62899b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4886ba65117415d62fc9994a14c3174f46f31c1d754e18e0e5edcf596bef20be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c0bc9f2969bf0573b56dd61e0f6e464069feaa497f6ea2a7b0add748c319064f"
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
