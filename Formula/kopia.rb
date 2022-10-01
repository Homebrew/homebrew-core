class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.12.1",
      revision: "5227d74996b6520f9f96e4203cfe00b832a60d5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bebd0d54cc166944c6e96b8187bb7a142e6614667ab90c7c58278a34e4da979d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d92ae17defba8535d4836544223fd1eabade2ac2b478b0097868f61b0429a537"
    sha256 cellar: :any_skip_relocation, monterey:       "e988dc5f8952883e20cdf295c9aa364083027963d0fcc1b1ead31b804e59c433"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdce9b267a748433ef2ee8af8646cc4b79ca979dd34540b518b6cc5f218e3c1a"
    sha256 cellar: :any_skip_relocation, catalina:       "bccdcd9016275177973e9167c9f8f03e19466ebf5871dcbd3360215b6585f857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aca8f174c8fa81de37f5fde8c1b1ea463ba540b54d360b02b19c1af33f9914b"
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
