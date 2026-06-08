class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "cbe837f1168a6903c3903b17d8e2f6f167530ff8ecd227becd5144720ee9a049"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6256c6a349f10ac14d5189117d5dca072a7dd1f38a1797bf136505a1f35f52e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6256c6a349f10ac14d5189117d5dca072a7dd1f38a1797bf136505a1f35f52e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6256c6a349f10ac14d5189117d5dca072a7dd1f38a1797bf136505a1f35f52e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5648db5d4792b66a0a04b46391fb503e7ed63120f26044f28a7f648473a0c36f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b3e8e8171de1a90d75a5062705316ac07f61c7d0ecd9b51b923072cbc6d633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8feb7283aa677e51f56a30db541a217e2e72aed473c9930a37140db55781bb93"
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
