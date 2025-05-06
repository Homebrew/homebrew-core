class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.10.20.tar.gz"
  sha256 "c90cab3aa5b3e2d564c381e5f4bf7805b9dbc3259dc920c133e4bdced3ca6f95"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af98439a6ef1b96ed3ce295a280396ecc72c647d4629969b2cda1d2711d6e999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af98439a6ef1b96ed3ce295a280396ecc72c647d4629969b2cda1d2711d6e999"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af98439a6ef1b96ed3ce295a280396ecc72c647d4629969b2cda1d2711d6e999"
    sha256 cellar: :any_skip_relocation, sonoma:        "1523fb037337abc768b9db2d8e07d51d053a564b8442431e567e47fe9d037c46"
    sha256 cellar: :any_skip_relocation, ventura:       "1523fb037337abc768b9db2d8e07d51d053a564b8442431e567e47fe9d037c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bcd1da4aa661f6927ef69e488e8362de903fd48970c465a42b82070d91447b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Harsh version #{version}", shell_output("#{bin}/harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
  end
end
