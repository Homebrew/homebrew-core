class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.38.3.tar.gz"
  sha256 "779ed8794908e7a2aac755ab561df8ef56d5f233594a6ec63fa3256463b4435e"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    manifest_sha256 "d004a3b68671b3311e2dee27414878bc54c9954e6f881e03fcbcd2c4f4e14012"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6dd5a87bd26239ace87d82be501d374edd32a4199f3a3e8b06d3b3fca30e014d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6dd5a87bd26239ace87d82be501d374edd32a4199f3a3e8b06d3b3fca30e014d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6dd5a87bd26239ace87d82be501d374edd32a4199f3a3e8b06d3b3fca30e014d"
    sha256 cellar: :any,                 arm64_linux:       "c5a1119283b683951e7ef329c383dcec7e38364d71ab88a6ccb756e1d002a09e"
    sha256 cellar: :any,                 x86_64_linux:      "ea104c5acda265a55a383ed2ca707c4fe56a876efe89776e4b9bfc8d775a6118"
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
