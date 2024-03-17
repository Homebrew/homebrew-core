class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "650d1f6d6920fb9914d6875c8d13bc220dd1fc16a5f451a6cd3f879a3eb8ece8"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b98250ee2c691f17fc0e2203f4c817d67eb16c6477d7bc0fa23bf6e7583c0f30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0755d840ff148686218e58e7d168ea7ddb76bbf1745380e7e8a44edf2484013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9920792592d7ce2cfdbdedfa7ec07dec46505855808ca6d085735642f01d6086"
    sha256 cellar: :any_skip_relocation, sonoma:         "12ec254a8fc2bf42c94287ea3fad150a6922db20078354a2d8077214727489e5"
    sha256 cellar: :any_skip_relocation, ventura:        "2bbfd50f16e34bc49aafce111b872f5fd5123d5e53e8acb1b0d0e682126102f6"
    sha256 cellar: :any_skip_relocation, monterey:       "4a439eea60f384cda5c76ec29eb0d1ac73eea71b433ff74d3c4fab5033bb1a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebff64bf5522c7603168d922e5d4d4d9c4823b7e691c94201ba2804c76477947"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
