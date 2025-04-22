class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "a60037470a637b7bb81e5b345a182d8907aafdbf8ab7836d8817b5e2e6496228"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b864912ec138ee9ef2ae649ef429a9fa0130ecba6fa19916bf6354e1154c847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b864912ec138ee9ef2ae649ef429a9fa0130ecba6fa19916bf6354e1154c847"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b864912ec138ee9ef2ae649ef429a9fa0130ecba6fa19916bf6354e1154c847"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e33f9481a4d829903e8ca9599a386d156783e78b23d6a7389ca6f4a08e536f"
    sha256 cellar: :any_skip_relocation, ventura:       "98e33f9481a4d829903e8ca9599a386d156783e78b23d6a7389ca6f4a08e536f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d0585cbbfd30b0f028b16611fccb5d3fcc741fe88a37c6618dd2fa8db9fb7e"
  end

  depends_on "go" => :build

  def install
    proj = "github.com/cloudflare/cf-terraforming"
    ldflags = "-s -w -X #{proj}/internal/app/cf-terraforming/cmd.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cf-terraforming"

    generate_completions_from_executable(bin/"cf-terraforming", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-terraforming version")
    output = shell_output("#{bin}/cf-terraforming generate 2>&1", 1)
    assert_match "you must define a resource type to generate", output
  end
end
