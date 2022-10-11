class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.36",
      revision: "ea275a3bafbc5b5c611e0b81bf2dd8a8add72f6b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b4e4c1bc3f3ddb68ce51ec9f236da5f556445874f5d5de9e0053814d4f7694b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b4e4c1bc3f3ddb68ce51ec9f236da5f556445874f5d5de9e0053814d4f7694b"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef96f3bacf6b67c1dc3cb3d4dadaba0214d30c97e000f7f0266973f9b03271d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ef96f3bacf6b67c1dc3cb3d4dadaba0214d30c97e000f7f0266973f9b03271d"
    sha256 cellar: :any_skip_relocation, catalina:       "3ef96f3bacf6b67c1dc3cb3d4dadaba0214d30c97e000f7f0266973f9b03271d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac56dc1cb22896ab62ecf3a0f0171e0938aef2e2c0b653e3f00eb1b5499a6b5"
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
