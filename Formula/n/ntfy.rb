class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "afa46845907dc9eef6f20e25a8ec65309377aa7f754610fc0f23798f45cc0a97"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b759fd0eddce76127e70b89be3d918bd37381437542d90b509a5ed54aead86dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b759fd0eddce76127e70b89be3d918bd37381437542d90b509a5ed54aead86dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b759fd0eddce76127e70b89be3d918bd37381437542d90b509a5ed54aead86dc"
    sha256 cellar: :any,                 arm64_linux:       "0d4e76048965d3647927ea8ea06ff3bbe2d193461bb0299e057bd9c5ef747854"
    sha256 cellar: :any,                 x86_64_linux:      "58a6aff6d51f086cd9f8483218f053161b97f4494fcdcbe2ed55fb7e9e6a5c04"
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
