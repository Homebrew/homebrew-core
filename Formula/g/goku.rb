class Goku < Formula
  desc "HTTP load testing tool"
  homepage "https://github.com/jcaromiq/goku"
  url "https://github.com/jcaromiq/goku/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "799e155c93937ccba830670fa25890d5fe53ceb01737926914d480ce0c39c752"
  license "MIT"
  head "https://github.com/jcaromiq/goku.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "657aa18fdf805a37325589e45c5e5bc1a25cba05b2177f7f14014f4acd12c525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6184dca87b2a076aeb54c91f4550746364ee1f771e63d9f66163b64e0d5ca0da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4013b6e044b064b1b23bf957758f95516f86101c4c57a115a0b63be0f4d6600c"
    sha256 cellar: :any_skip_relocation, sonoma:        "644ba3fc5c112ba74948d5db227a8e497a03c88a255b1cc90ab4667ce2c56ab3"
    sha256 cellar: :any_skip_relocation, ventura:       "a04067161f92ebba9334d19183d32badc121e775690d6fb18459406e41fd8c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e46c4374fbf1f3216b25c3e5b7a78ea69a4c62c80bbf82eefadbc23e28be2db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/goku --target https://httpbin.org/get")
    assert_match "kamehameha to https://httpbin.org/get with 1 concurrent clients and 1 total iterations", output

    assert_match version.to_s, shell_output("#{bin}/goku --version")
  end
end
