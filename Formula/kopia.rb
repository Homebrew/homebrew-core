class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.12.1",
      revision: "5227d74996b6520f9f96e4203cfe00b832a60d5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8180adf19ab951183cf48ad9b51e86d7b14624aeb3b971a95592640c02143d7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23651e093d8c666791046edd4003f085b09368f95f23b966d6bbe7ce7378bb1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d20c96560acc71c22cf424f9582c201d79ddc9325975516cc6cb1dcc44fc1133"
    sha256 cellar: :any_skip_relocation, ventura:        "aec082f3f92a8420589c8af73ec74dce5545a1e587d1d2ca8e2da512e8b06363"
    sha256 cellar: :any_skip_relocation, monterey:       "4e87bff9bf7cfdb1b05ea31184d5e92aeddc3ce93c5706753f00c485d5dde4f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "19097e5b27489e987ad3c2808e49b755ca7a3036c015fb24dbccb914082a9b80"
    sha256 cellar: :any_skip_relocation, catalina:       "7133b0f20f9879ff36468603b3ced1e1c6d324a459f62c24b318d54e2a08b560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7cd14a977ba5cc1fb7fa98e5284afd1b0b439052fdef99acf86722c43602a0"
  end

  depends_on "go" => :build

  def install
    # removed github.com/kopia/kopia/repo.BuildGitHubRepo to disable
    # update notifications
    ldflags = %W[
      -s -w
      -X github.com/kopia/kopia/repo.BuildInfo=#{Utils.git_head}
      -X github.com/kopia/kopia/repo.BuildVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kopia", shells:                 [:bash, :zsh],
                                                      shell_parameter_format: "--completion-script-")

    output = Utils.safe_popen_read(bin/"kopia", "--help-man")
    (man1/"kopia.1").write output
  end

  test do
    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    output = shell_output("#{bin}/kopia --version").strip

    # verify version output, note we're unable to verify the git hash in tests
    assert_match(%r{#{version} build: .* from:}, output)

    system "#{bin}/kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_predicate testpath/"repo/kopia.repository.f", :exist?
    system "#{bin}/kopia", "snapshot", "create", testpath/"testdir"
    system "#{bin}/kopia", "snapshot", "list"
    system "#{bin}/kopia", "repository", "disconnect"
  end
end
