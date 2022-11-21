class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.36",
      revision: "ea275a3bafbc5b5c611e0b81bf2dd8a8add72f6b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0badbc531d64aa8a1fee91f03cfed919be428bab7d7ce02192e2b9eecbbaf32d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3397d51bc458acbcfe9003fd55bd0fc086ed43f41d9f41a0c9cee48849aab809"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3397d51bc458acbcfe9003fd55bd0fc086ed43f41d9f41a0c9cee48849aab809"
    sha256 cellar: :any_skip_relocation, ventura:        "1726c30e8192671268f2d0a08906aae1b4883dd802050b574c22c2904df4d235"
    sha256 cellar: :any_skip_relocation, monterey:       "45e4853cf61137a5113b0301ab8e875ab93b01c22db62b91be4173c935cf55e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "45e4853cf61137a5113b0301ab8e875ab93b01c22db62b91be4173c935cf55e6"
    sha256 cellar: :any_skip_relocation, catalina:       "45e4853cf61137a5113b0301ab8e875ab93b01c22db62b91be4173c935cf55e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f16652a861ae384f578521d720ac4dcf9bf5280582d08e3f5da7a9c9a41f3f22"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X go.dagger.io/dagger/version.Revision=#{Utils.git_head(length: 8)}
      -X go.dagger.io/dagger/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/dagger version")

    system bin/"dagger", "project", "init", "--template=hello"
    system bin/"dagger", "project", "update"
    assert_predicate testpath/"cue.mod/module.cue", :exist?

    output = shell_output("#{bin}/dagger do hello 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
