class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.29",
      revision: "5c7f208219aba9f90b252027b6e3d8069b5e8017"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d566dda8a03274163b78d02b3c71b9afeda4645a0374af073dea58112736a9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d566dda8a03274163b78d02b3c71b9afeda4645a0374af073dea58112736a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "4acb76cf054dde66fa168df17047869b4cbdacb89ae82fd422b70f2a86357859"
    sha256 cellar: :any_skip_relocation, big_sur:        "4acb76cf054dde66fa168df17047869b4cbdacb89ae82fd422b70f2a86357859"
    sha256 cellar: :any_skip_relocation, catalina:       "4acb76cf054dde66fa168df17047869b4cbdacb89ae82fd422b70f2a86357859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9a2334a13f6af28438553f5418fa89b6faefffaae0f9e4ca2153b3b75066a84"
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

    output = Utils.safe_popen_read(bin/"dagger", "completion", "bash")
    (bash_completion/"dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "zsh")
    (zsh_completion/"_dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "fish")
    (fish_completion/"dagger.fish").write output
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
