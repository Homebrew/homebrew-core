class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.13.0.tar.gz"
  sha256 "c45a78dfcebf357ca7d673685d16ff835b49318e60f7a919a00181df84e4361a"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b96d7092ba0bd1f9a9ae67c0d31f0dac3a3642cf3acadbf7cf7947c86559de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b96d7092ba0bd1f9a9ae67c0d31f0dac3a3642cf3acadbf7cf7947c86559de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b96d7092ba0bd1f9a9ae67c0d31f0dac3a3642cf3acadbf7cf7947c86559de5"
    sha256 cellar: :any_skip_relocation, ventura:        "510a9c1462cb3bd0b76110811e01a899aa84dc927a21065d2d12a490e8373978"
    sha256 cellar: :any_skip_relocation, monterey:       "510a9c1462cb3bd0b76110811e01a899aa84dc927a21065d2d12a490e8373978"
    sha256 cellar: :any_skip_relocation, big_sur:        "510a9c1462cb3bd0b76110811e01a899aa84dc927a21065d2d12a490e8373978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1971dc3696820b115b87b4237f9ab8532a529f12f93908310483cb9611d6e7d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
