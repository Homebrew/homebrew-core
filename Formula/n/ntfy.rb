class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "c8de56e2bc3a9b738b1927c922c452bab5c3eb45a3870e51c01cdb43030abbe0"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d66e082764858928e2d0cdccbe2a2e1973db935f0a0069e717f08708474e2af3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d66e082764858928e2d0cdccbe2a2e1973db935f0a0069e717f08708474e2af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d66e082764858928e2d0cdccbe2a2e1973db935f0a0069e717f08708474e2af3"
    sha256 cellar: :any,                 arm64_linux:       "a48e340c687717882c4badc37ba4372fafb1e0936e20ad72d4c3e9ee306ec692"
    sha256 cellar: :any,                 x86_64_linux:      "512b51816edc1fd759885e04e9c56d85367c9a3d96f36c7ecec16d1fc04cea4f"
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
