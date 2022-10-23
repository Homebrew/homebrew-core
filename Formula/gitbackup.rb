class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.4.tar.gz"
  sha256 "1d110658874dcb96d9de7cdbb7a54bdaa6e01a77a2952bf881a20d58235d1e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a3e2b3b0d5c4f292cb5bb1b5d8951ab6f64af054f33bd778a264806eda40d64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a3e2b3b0d5c4f292cb5bb1b5d8951ab6f64af054f33bd778a264806eda40d64"
    sha256 cellar: :any_skip_relocation, monterey:       "151d98f4d768b5da7be7c52237f6e954e1fc30a091a4419dd459de4eb3967b21"
    sha256 cellar: :any_skip_relocation, big_sur:        "151d98f4d768b5da7be7c52237f6e954e1fc30a091a4419dd459de4eb3967b21"
    sha256 cellar: :any_skip_relocation, catalina:       "151d98f4d768b5da7be7c52237f6e954e1fc30a091a4419dd459de4eb3967b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b1f0bdce8d6e13fe97c6c6aa8603ebbc1c52481be1f32410d62de246979635"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
