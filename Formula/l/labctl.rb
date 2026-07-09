class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.97.tar.gz"
  sha256 "7cbb8898abd572fd86b8b1a079a1fe81f35bc4a694cb5cd22e2271bb4d76f2e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02395c24e7ce0a94858c6f54177b87ef2f9f101958a15a2fc8888439fb7a6020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f62572d359aff4e492bfc4d4137cadcf57840ab70bff8e21dd5b245d3d1ebfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbaba53799bae189712f09c2f237033bed99a80a7cec68bf97b80cf9b2076e6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5cf4bbd34c01ab9b20c0ef8858991edbfa713c4f2a4aff55a057a17c46bd4f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82597c3e1d0e2c8b64f733a35b7e3f425276cc8267896ce2ed1f167eb7bbf55e"
    sha256 cellar: :any,                 x86_64_linux:  "0a3f0b9df06fdc7c3f917d8a90738db61104e6dee0ef517450949fc481eeb0e4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
