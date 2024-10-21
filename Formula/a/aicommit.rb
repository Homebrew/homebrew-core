class Aicommit < Formula
  desc "AI-powered commit message generator"
  homepage "https://github.com/coder/aicommit"
  url "https://github.com/coder/aicommit/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "393afe45eb2aa438a9d3b211aa19d6e46948c6e6d970ce0c694d5b3897075c99"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba5e2c2761096b1bf8398735271267df4741f9a5c475317548728c1157c9b639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5e2c2761096b1bf8398735271267df4741f9a5c475317548728c1157c9b639"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba5e2c2761096b1bf8398735271267df4741f9a5c475317548728c1157c9b639"
    sha256 cellar: :any_skip_relocation, sonoma:        "d76be98e52b540cb4c50ca7faa8cd3935de27443cc5a75d8c6e78f35333bd226"
    sha256 cellar: :any_skip_relocation, ventura:       "d76be98e52b540cb4c50ca7faa8cd3935de27443cc5a75d8c6e78f35333bd226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "571232f6e124681c01a471825cf01491b3621c6dff995f37296fa6fbce3f6d9b"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}"), "./cmd/aicommit"
  end

  test do
    assert_match "aicommit v#{version}", shell_output("#{bin}/aicommit version")

    system "git", "init", "--bare", "."
    assert_match "err: $OPENAI_API_KEY is not set", shell_output("#{bin}/aicommit 2>&1", 1)
  end
end
