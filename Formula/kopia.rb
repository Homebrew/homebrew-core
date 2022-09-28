class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.12.0",
      revision: "05e729a7858a6e86cb48ba29fb53cb6045efce2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "538d8c8245db819eadf5160f16f9bcb832bca5b7c891053d9bd061847a823aed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d6eb69df0675894826eabd018e747c841dab881539f44284967eef9d8c5924e"
    sha256 cellar: :any_skip_relocation, monterey:       "fe30ed73aeff3de551e362147c73e8bf56f412f7522182a29510c1fc5ba54cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "64059de276db6c41f8b18f02cc04720d5862e4170dbce14a32f5839b7f104928"
    sha256 cellar: :any_skip_relocation, catalina:       "f6c200825635c529c68cce9ba81ca52be2343b88e73ba84a90f3c707b8087677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12ab919d8581bc457246032b974da03fe0fbaedaadcd47022094b040e408c8a5"
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
