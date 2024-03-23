class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.16.0",
      revision: "488901740dde3966697135ad094c3930fe14bb1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf80f785401241e76181af386fde858abb64d185baf35e90d03ca9b676e3fec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8a020de8fcd08e6dd01834fcde242f8b67af42b3be5d39d70fe43ec15da374d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd135f46b697ffa632ecc2967d58f205bf154e56fb358c839ec455a6a326eb79"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4a44b366382d6e317230b6812203fdebc78d3f9c0782d1461bc910b621e8fd6"
    sha256 cellar: :any_skip_relocation, ventura:        "d0cd0d66b11d6b3d18e4ad4e8994a0e3e14461ce7eb678fd0e224c4ce0cd65af"
    sha256 cellar: :any_skip_relocation, monterey:       "09eb8a32950d8adf03e96b732f9ec1b3668ceaf58cb2b1db23b7ca5a7c4996c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58795eaf28548324f4eb03a3af9a0b1453547841826deb161b0b4c78ad78a63b"
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
