class Countdown < Formula
  desc "Terminal countdown timer"
  homepage "https://github.com/antonmedv/countdown"
  url "https://github.com/antonmedv/countdown/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a7b037988a4602196bffaa2cae0fa7d03b27197ccc1c6f96d258777472b76d87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1133ecd11d69ca065e90d50d259453b905088abb1a5153386f4e2b1ff0f6ae4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1133ecd11d69ca065e90d50d259453b905088abb1a5153386f4e2b1ff0f6ae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1133ecd11d69ca065e90d50d259453b905088abb1a5153386f4e2b1ff0f6ae4"
    sha256 cellar: :any_skip_relocation, ventura:        "01a8913454b99729ed94976e01701ace48ad0b7f78d32d5f8b3562949184ff07"
    sha256 cellar: :any_skip_relocation, monterey:       "01a8913454b99729ed94976e01701ace48ad0b7f78d32d5f8b3562949184ff07"
    sha256 cellar: :any_skip_relocation, big_sur:        "01a8913454b99729ed94976e01701ace48ad0b7f78d32d5f8b3562949184ff07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a81293ef91b725903f63ef4fae5ab8e6dafe3e2f5a3285f40438616d03f0621"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pipe_output bin/"countdown", "0m0s"
  end
end
