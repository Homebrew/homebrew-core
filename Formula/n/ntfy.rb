class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "1f46463acc177479860861cca8d7ec7da92244eab7ea42d20a89c17055d6641c"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1339293ed92f4e8ce56cd4c7c7b0ec8d988ed1398d958b251b3dc2ff452d201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1339293ed92f4e8ce56cd4c7c7b0ec8d988ed1398d958b251b3dc2ff452d201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1339293ed92f4e8ce56cd4c7c7b0ec8d988ed1398d958b251b3dc2ff452d201"
    sha256 cellar: :any_skip_relocation, sonoma:        "d66235b8266fa36d75fbed66579c8faea60e8bc45f2ad22f1a5d83c1af8237b0"
    sha256 cellar: :any,                 arm64_linux:   "f26f12609259dd7d6d28216ec20b92ca5236a00f2434c85cb90ee6faae573f9a"
    sha256 cellar: :any,                 x86_64_linux:  "5b6e865be9c3d231f28e65389e098540e45d49847b7ada28262a6bce1ffdca7e"
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
