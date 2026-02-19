class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "2d2e4bb79998b52355407766cbf84e21fb7c650fd93c0a3663f3fcabadb2544d"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c018ba855796004e3b4dfa1582c5c9ed9964df75ebf23383dc5c5c834860e9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c018ba855796004e3b4dfa1582c5c9ed9964df75ebf23383dc5c5c834860e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c018ba855796004e3b4dfa1582c5c9ed9964df75ebf23383dc5c5c834860e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a068412e199efd658905bae38a8e3112d08952b7d6dd885664a1e42ebb3b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b41bdc8af0342561e1f443ab76329dcb13fcf3fff9a8076c38ffad01185a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93854dcbd600a5c3b37d52c0c0b21fe7697421c5850814368d1e074a3f263c7"
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
