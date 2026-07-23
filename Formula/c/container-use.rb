class ContainerUse < Formula
  desc "Dev envs for coding agents. Run multiple agents safely with your stack"
  homepage "https://container-use.com/introduction"
  url "https://github.com/dagger/container-use/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "951105f0b4a9bfd9f52e7bb3a2d245e800df4b8449704cd34001833ee888a02d"
  license "Apache-2.0"
  head "https://github.com/dagger/container-use.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76b8ffe481648077829aef33f240710acbbdbe6d4e7b3892dbba16289cd943f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b8ffe481648077829aef33f240710acbbdbe6d4e7b3892dbba16289cd943f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b8ffe481648077829aef33f240710acbbdbe6d4e7b3892dbba16289cd943f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "dabe5a2e7fb92ad5d63699636a910f7d4feb2de91ec170fc72f3321df737c790"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345e9dc530b7d7dff06c18719845bbf55254a801487175ab319ec6c9271ee6cc"
    sha256 cellar: :any,                 x86_64_linux:  "7f071936a8825c76f0d343aaa8990f5aab48e2f7450d0938a3c8ac4ba5dce503"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/container-use"

    generate_completions_from_executable(bin/"container-use", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/container-use version 2>&1")

    system "git", "init"
    assert_match "No environment variables configured", shell_output("#{bin}/container-use config env list")
  end
end
