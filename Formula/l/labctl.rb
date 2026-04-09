class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.66.tar.gz"
  sha256 "fb0456c55824db86775b4d759859f7997139d4e7865eb5ab488c0c2bc300c266"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d02b6fdb82c367a7bfb74c257f9a9ecbd163252726b4a25c01c12875a2e35267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d02b6fdb82c367a7bfb74c257f9a9ecbd163252726b4a25c01c12875a2e35267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d02b6fdb82c367a7bfb74c257f9a9ecbd163252726b4a25c01c12875a2e35267"
    sha256 cellar: :any_skip_relocation, sonoma:        "78b4583ee524b8100feabe92a9e91cbdca53bfdc14f50a3b7350f2bd8435e299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "effc1e04d18d099516634c8c4e832cacc4eff48aa1680dde21eb08429eae92b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "168bedb699fc97321091477cf86ed205774e793077181febff8c84dd38982e12"
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
