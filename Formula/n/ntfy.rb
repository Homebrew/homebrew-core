class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "ffb3e7b9f801e9e14a1fa0f21020ef4ddc36139006cb8e7fb9236776db593707"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "007237ebd53cfdeaf388c80e55fa59a2b906144af0a76a430681b05dcebafd24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "007237ebd53cfdeaf388c80e55fa59a2b906144af0a76a430681b05dcebafd24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "007237ebd53cfdeaf388c80e55fa59a2b906144af0a76a430681b05dcebafd24"
    sha256 cellar: :any_skip_relocation, sonoma:        "679589767847ffe3e8e1937831a1f33850f683a18e7dd11a9838051a35b8084b"
    sha256 cellar: :any,                 arm64_linux:   "0c1d2783bce96af2336c714a10e219616e1995760020fd21d34aa16dfedbfaab"
    sha256 cellar: :any,                 x86_64_linux:  "64c9778330747b46e2908d1e7e67efce691497fe55ad57ff4ff64f65692abb1d"
  end

  depends_on "go" => :build

  def install
    tags = %w[noserver]
    if OS.linux?
      tags = %w[sqlite_omit_load_extension osusergo netgo]
      ENV["CGO_ENABLED"] = "1"
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end
    end

    system "make", "cli-deps-static-sites"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end
