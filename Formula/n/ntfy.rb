class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "02323e45a04de175456701c9ff741c8e00602ced22d8fd59842d88ab66e267cf"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2625c160963c87803a10cd36e64a574acf84a62cb0f2ccfa34a2db916d04bbf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2625c160963c87803a10cd36e64a574acf84a62cb0f2ccfa34a2db916d04bbf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2625c160963c87803a10cd36e64a574acf84a62cb0f2ccfa34a2db916d04bbf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a9fc94a4d4b8d907433ce6df928d01e46b27abf3d549f9f9934bf1dc20fd74f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a57730c108c02f4e85b1ada72f800ddd0aed4c430cd078c483ae446bd16e7e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b6b20cf1fbe3795add26903f2cfb5ea3d345da80a8f5b177829125e1001737"
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
