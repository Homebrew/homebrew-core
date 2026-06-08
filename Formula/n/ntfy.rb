class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "4b9e47923fe4b99af9f359da3dbbcd3e07dc1e5543fbc08f6cce095b36ce45c1"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebcb1db2b1648b695f1488625b9982f79f5cc137d9babfc19dd08fc009f42379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcb1db2b1648b695f1488625b9982f79f5cc137d9babfc19dd08fc009f42379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebcb1db2b1648b695f1488625b9982f79f5cc137d9babfc19dd08fc009f42379"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5dec867ed637c2e7de4f47c414f8bc7c9243a5927832ec156848b07beacf3b8"
    sha256 cellar: :any,                 arm64_linux:   "bf441da11144becbca1c6c5ed46ebb224907aff70d85f4b0a6b3faa6e3857d5e"
    sha256 cellar: :any,                 x86_64_linux:  "f75d55eca137a3306aea1ba0b78ac972c868e3e40295bd0adbf46f9bae01e6ad"
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
