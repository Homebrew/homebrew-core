class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.35",
      revision: "00cde752120b87478e5cfc00877935164396afe8"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a47d4815b5e9ce3bba2ff2eefc4e66f84bd07adbef2532136e8be373f46b1c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a47d4815b5e9ce3bba2ff2eefc4e66f84bd07adbef2532136e8be373f46b1c6"
    sha256 cellar: :any_skip_relocation, monterey:       "affbb5af44c22bb61dd4a7c7b4383e22731beeb14801b59f3e1e521355e588bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "affbb5af44c22bb61dd4a7c7b4383e22731beeb14801b59f3e1e521355e588bd"
    sha256 cellar: :any_skip_relocation, catalina:       "affbb5af44c22bb61dd4a7c7b4383e22731beeb14801b59f3e1e521355e588bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78b756ed07407b6ea3f0b375bc3c857cf5963d12dd9287fe69eafdb35dbff46"
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
