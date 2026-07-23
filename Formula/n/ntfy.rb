class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.26.3.tar.gz"
  sha256 "6a1378a383133ae500bbe0658eca06a536cafd5c46c83cb1412e6dc4bf49cd70"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9118586c8b5648b51d8ee6b80b28ba4e5eb4b1689f67a83e52290b5f553fc71a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9118586c8b5648b51d8ee6b80b28ba4e5eb4b1689f67a83e52290b5f553fc71a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9118586c8b5648b51d8ee6b80b28ba4e5eb4b1689f67a83e52290b5f553fc71a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2f953845478538ac702c80a35391f1e0b217d1e61bfbfe1e4fdc09f0d3fa188"
    sha256 cellar: :any,                 arm64_linux:   "2eba3d0d061edae4969319c603603c2e9511e07353f17b9805489e619dc86cdf"
    sha256 cellar: :any,                 x86_64_linux:  "17a67145873ffec249ed8dd8bd1c90ce04ef2f8dad880814a4ce1957befe9a3c"
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
