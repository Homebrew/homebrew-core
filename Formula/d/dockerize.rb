class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "47582c1a07fc7d886ba7bda51ee2d8ab17580003b23f50792fc30512b29e7910"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5ec84fb8fbb2ab6d3175e63a541974373bc0f2e2464ae9076137db779200bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ec84fb8fbb2ab6d3175e63a541974373bc0f2e2464ae9076137db779200bb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ec84fb8fbb2ab6d3175e63a541974373bc0f2e2464ae9076137db779200bb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "822b1c647fdd56d7f0b240aed0baf832a6126a497b0cc02318ae2ba1b1d5e15f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5310cfbff0584493f275849cbabdc079a0c1ed5d066a3ca42dd077723b85cd52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910b1f7c1c83b9373a0718f221296c001f3652b359c885ab61b23202a6cae623"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
