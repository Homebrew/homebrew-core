class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "a156f43b62168531f999f4ee1fb39b6d0057e55e4f703c96181be32950b3c461"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1b2c37874f97f7d25129b70ddb8c74d81bd838752bf52904f69acc25c11c480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b2c37874f97f7d25129b70ddb8c74d81bd838752bf52904f69acc25c11c480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1b2c37874f97f7d25129b70ddb8c74d81bd838752bf52904f69acc25c11c480"
    sha256 cellar: :any_skip_relocation, sonoma:        "553325e795e1f955251f53fcb2c91e4e24c64b12de9559039c018cf567e68f5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af8eb457f9132d90da407300218c8b4c641d39db3d0d67d1aabcd117935e993a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1680a1b9edf2bb8a7656961ac6cc13a5ee126fdae287b7ce0f5157c6ee6916"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}/dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "Dockerfile is not formatted", output
  end
end
