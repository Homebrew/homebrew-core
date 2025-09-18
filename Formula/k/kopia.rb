class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.21.1",
      revision: "0733cb4d2a731dbb92d927f66230694e014f4df2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0ca9226b162822dfc826e71cbb0d42c88a368bc5b671e19e639523a13ece555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc1b7cf8b07306bb0dc8e07549761a6a15e957aa8b9fb74fcd27383af40baa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f0c6e7024ab0c476314f6f2371b4b23f92bfa2d53dab3773f0cf50e4ad86898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91ad4779a6ab5dad37b91770949cc82bfb19b506dba84a854d0bb70c158fb94a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bbdd7a23f7dda2d8f399d20f7534530f122d04ffa8076aad8c11e26e11e9047"
    sha256 cellar: :any_skip_relocation, ventura:       "6bafcd38d320e1796a1703bb5b9170968a2e4abffcc2e910961376779b471c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deede3e623d80038a966edbedfbdb208c9cddba64c2e7cb3f7a722a7c025dcec"
  end

  depends_on "go" => :build

  def install
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
    assert_match version.to_s, shell_output("#{bin}/kopia --version")

    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    system bin/"kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_path_exists testpath/"repo/kopia.repository.f"
    system bin/"kopia", "snapshot", "create", testpath/"testdir"
    system bin/"kopia", "snapshot", "list"
    system bin/"kopia", "repository", "disconnect"
  end
end
