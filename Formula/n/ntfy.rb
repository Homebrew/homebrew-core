class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "88011af10d6af3948d735cd5add036b6b65996c7de898aa2116ec7b430d62afb"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e13d513a284bb6f0699ae3b506b24c8fbff55a258176caf457a72cc7dde5ef7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e13d513a284bb6f0699ae3b506b24c8fbff55a258176caf457a72cc7dde5ef7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e13d513a284bb6f0699ae3b506b24c8fbff55a258176caf457a72cc7dde5ef7f"
    sha256 cellar: :any,                 arm64_linux:       "fe39766818e2fcbfe6200694ac0d6716b068e288bf94f78557864e403f35c72d"
    sha256 cellar: :any,                 x86_64_linux:      "1355d3b7b53511f52c52a381f8ef7ac57c32cf493097eae775edc1a5f219e402"
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
