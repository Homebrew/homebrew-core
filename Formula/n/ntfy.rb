class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.37.2.tar.gz"
  sha256 "4a61b0ddc74dacf386ed8f939bd59dfeab1091157d091285731fe3bd595cbcd2"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8346f31ef31a2bffa70c6405648f50a963128c73fe08d7a47143ebe9967332df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8346f31ef31a2bffa70c6405648f50a963128c73fe08d7a47143ebe9967332df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8346f31ef31a2bffa70c6405648f50a963128c73fe08d7a47143ebe9967332df"
    sha256 cellar: :any,                 arm64_linux:       "f42fc8f7fb54c4b774ee5dabb549fbda5668c9d0c5838724c43b40a9d13b81c7"
    sha256 cellar: :any,                 x86_64_linux:      "e7b08b83e28ca69abbc0515e7586f1747434f2a791f8ca3890af1df1e5a0758d"
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
