class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.16.1",
      revision: "4f1c994c39ff76270f71c5b3dcec774df8b3c4e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffeecbec8f4537b1ea0e1ba13e87a69fabceffff1035b0c9bc857039d041dc21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772ac0cbe028fa018035425ea0bf5b25f2b27b7fbe1e6e6991a8b3a72f3f0844"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c43c3d5eb0dbb147a6fbfcab6ea6a38bd160a61ec0c1175c9c23ef41abcfc3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3494a4be818a337c7820a8b12aad44e190c52b4827f68259548262b34f0bc212"
    sha256 cellar: :any_skip_relocation, ventura:        "6ca1333f955cfc958bef69ab24a56265ad0578b7fda75864db84b363a80dea38"
    sha256 cellar: :any_skip_relocation, monterey:       "fbb0a5b2dba45fa0208cd919a987de1a271f9373fd42da434b60b934222e02c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b39f0f54269342f9087eb644444654bfbb65670e4178ef7fbdc013cf8b7320"
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

    system "go", "build", *std_go_args(ldflags:)

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
