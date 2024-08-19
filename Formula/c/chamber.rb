class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "20ab38fa94daedf2965997c487223831035028de93ddf73c6b92e68558e229f7"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5f5776280aeba4813dd840d48d5c3343ae04397eb9ef0eb3a71f93fe0376a61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dcd2a7a70b5fd8d9bc904b3ba44b3b01184c8c3de0b63a5daa0f31e6cb5877e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef1cfaf8233cd90e0247ff7607eb23064373ee132922b9498d996d69fa10b0aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c247e4d0432f203263833c2c314533d71e4bab53a29e442ecf8d0f50a76a7de"
    sha256 cellar: :any_skip_relocation, ventura:        "739f7ad29391e9bd171520ada3756c1248bb9a5df098b112c280ada720492900"
    sha256 cellar: :any_skip_relocation, monterey:       "954fa1f84327a6e6fe1a8ffacf1da903a58c2c02a4ec42b504c4e3de99011017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce21254f4e6577ba1bf597c5624e21b29ff971a52a78297fd9c04c47f11d883c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "Error: Failed to list store contents: operation error SSM", output

    assert_match version.to_s, shell_output("#{bin}/chamber version")
  end
end
