class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "feceb63f17513d8310efbe81c660bf48f6a3bd8040ab00a45dc4c9fbf591033f"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "616e59f71899b1225cb0de54e14a6b39f32620bbfe572cddc1b089de7041f07a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616e59f71899b1225cb0de54e14a6b39f32620bbfe572cddc1b089de7041f07a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616e59f71899b1225cb0de54e14a6b39f32620bbfe572cddc1b089de7041f07a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a131af8db5ec613549d66beea5a8c72e458b79a3670b4a83a79b4c86b0dc42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb66081d92a1e6c44bd49402bf1f4307628565e582030a7d36fa8ab70ec2001b"
    sha256 cellar: :any,                 x86_64_linux:  "49e3e106d2bc3011a7cb725584c614ac6fe4b3bf71bb886ffc9e38477e4771b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/reteps/dockerfmt/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"dockerfmt", shell_parameter_format: :cobra)
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
