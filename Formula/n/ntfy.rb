class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "a799cdcbb9eab1dfde89825b72312493d7e57462b84b1717da49ac891ba9836d"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f0bc3a8d644d81e438c4ee6bcc03c219aec584bd21508940f8e975d07df36ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f0bc3a8d644d81e438c4ee6bcc03c219aec584bd21508940f8e975d07df36ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f0bc3a8d644d81e438c4ee6bcc03c219aec584bd21508940f8e975d07df36ba"
    sha256 cellar: :any,                 arm64_linux:       "11f22406a0ad0399b58124882a51768c8cfc47e351d14e9009bde29ec5ab9798"
    sha256 cellar: :any,                 x86_64_linux:      "d1f7e3a33d1ab0ca7fabdc7f2759334f3a88338a90702077b979d6cc040d6733"
  end

  depends_on "go" => :build

  # `test do` block publishes a message to ntfy.sh
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
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
