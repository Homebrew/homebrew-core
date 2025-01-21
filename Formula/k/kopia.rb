class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.18.2",
      revision: "c70f1a1c1164ee8676f85f9a1cea6de0a782a3ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46f26a749b222822808abad363e0d12412be881c606673138cb3ea89510d408a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e46083fef1f5f54ea37be417c4beaa2d75a47c111f5bf8c94b5c7cb9375fce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddc9bd3b92ac306a9897dfc5cebaf4d1e8fa71af5cdf64051f56b73f06b06c04"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ee4ec73278fce4c2b2b490e6b5d0eea8ff7019f6139e2c970fb0596adeb64f1"
    sha256 cellar: :any_skip_relocation, ventura:       "52a7548ef68d846e3b375b4d02f5660b944683343fdc741f15192e20e4e494ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc166972aaf5c62bb65300d1b8d9e51dc8c78c0b6b24a872397ff87f8052ce3a"
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

    system bin/"kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_predicate testpath/"repo/kopia.repository.f", :exist?
    system bin/"kopia", "snapshot", "create", testpath/"testdir"
    system bin/"kopia", "snapshot", "list"
    system bin/"kopia", "repository", "disconnect"
  end
end
