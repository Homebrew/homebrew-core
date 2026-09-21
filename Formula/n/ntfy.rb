class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "edfa7efdfd7e76a250bdec021c464ac3dfcaf928a4710433946e2a86c6d66c9e"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10b7a63cd740dbd99a747943cb1d1ead5bce4b9563439cb91fe4a140a176a9bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0bba97e142047a8416cb9f8be6dfff235776526295ee0137e3e436dfd767a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0bba97e142047a8416cb9f8be6dfff235776526295ee0137e3e436dfd767a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b0bba97e142047a8416cb9f8be6dfff235776526295ee0137e3e436dfd767a0b"
    sha256 cellar: :any,                 arm64_linux:       "5a0e1fdd492a7485ca935bd09a78b7ef12cd8a169a739f95e12a179e6cc8d6f6"
    sha256 cellar: :any,                 x86_64_linux:      "31c80978a13521946e92c1fe8ffb4e4a63cc1db666278f048b3f68f95dcd993b"
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
