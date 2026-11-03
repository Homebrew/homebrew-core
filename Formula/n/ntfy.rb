class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.37.1.tar.gz"
  sha256 "b687f6d34e69ab0867db5654b33579e2d705e149e09757a0eeadbe4ba184800d"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b79f121324cf8af41d3a71ef932acf9d7aea439acdc44f38cad5499815dbd3b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b79f121324cf8af41d3a71ef932acf9d7aea439acdc44f38cad5499815dbd3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b79f121324cf8af41d3a71ef932acf9d7aea439acdc44f38cad5499815dbd3b5"
    sha256 cellar: :any,                 arm64_linux:       "fc66a59adf2f3c311ed3c50f8a3bdb80f5ac3037b3283032a71f228aa4c49f35"
    sha256 cellar: :any,                 x86_64_linux:      "d382b2dd9735c3d6947ba63b3d8beb31a42bca9263ffc66a290b8298f4fe002a"
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
