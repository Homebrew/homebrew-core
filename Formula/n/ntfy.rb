class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "a73c12770086f884327ed133b869ccaffe182910873f0718f101cf78847ea957"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "000a27d7ef70994c8fa10f2459f48ba141de78939642665616b4b008efd1afc8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "000a27d7ef70994c8fa10f2459f48ba141de78939642665616b4b008efd1afc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "000a27d7ef70994c8fa10f2459f48ba141de78939642665616b4b008efd1afc8"
    sha256 cellar: :any,                 arm64_linux:       "82bfbf2c35907402cfb1716f044ba264238e501b34f060e3c87dd053dc94062d"
    sha256 cellar: :any,                 x86_64_linux:      "e6860ff1f92717cd77fee2d6c4ba3e65c5fb8499dde8931da4ed9aba38080dee"
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
