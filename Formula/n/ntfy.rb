class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "fe14d88856a4e0d3dec478c224d980f81df707f6ee5b7d68322c6d9ace0e90ab"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32946aecdd2142f9ea1850bae52bd1eb4a816dd7223fb4b84dd2ef8544bd574f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32946aecdd2142f9ea1850bae52bd1eb4a816dd7223fb4b84dd2ef8544bd574f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32946aecdd2142f9ea1850bae52bd1eb4a816dd7223fb4b84dd2ef8544bd574f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9226f2385209ce7b532d4eb035ace942d18d10ba09de65ef028617145cfd9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba9db605cd256ee75cac13de615e7361fe4d71e79590db245dbe09ef4e9c378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e865bd8d49185af4cbf0d59c9f768e1c82f5167d062d2579aa04a15d77dc352c"
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
