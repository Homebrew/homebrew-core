class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.38.2.tar.gz"
  sha256 "1a5f8eda8d3615204436f4894add4d7dd19ce59854e5585909ea8f671bcb2998"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    manifest_sha256 "73a45d168e36e8e38763eff1bd747a7ea375e4a6752a4d3211920b9006d8a760"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4627ca450d82feb6555e9ae017dd002b9ff864f7fae3d686dafff65c236a686"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4627ca450d82feb6555e9ae017dd002b9ff864f7fae3d686dafff65c236a686"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4627ca450d82feb6555e9ae017dd002b9ff864f7fae3d686dafff65c236a686"
    sha256 cellar: :any,                 arm64_linux:       "0fa9d5b5bc8337c4eaccf01dc56ee254c5e9ccaefc7c4250240d9beacdac06b2"
    sha256 cellar: :any,                 x86_64_linux:      "270b93e4b22c3a019c0ac211fae8aa04b6fbe9ce054d3b7cc9b74acc9277843a"
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
