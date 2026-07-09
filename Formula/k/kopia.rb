class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.23.1",
      revision: "72ec08fd8edb86c67ed27099bf1b955e1f308ffa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33461d9506786f717e21efac9d3a14f5198df27763ff38972fda41c51c593f61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc15f731c30fa347cbfdd76fbdd345d20cc0d2383e1668819d66117bb4a4c5a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebcb3082ccc4f3bd6bc1615b462701ca2cae4c493e043c1bb6e830a8bc9cde41"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d82488ba5fd33cae7a98359b7547898e01c16ef31f894231281756a15bfc8e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1075ae0938f655826dc3f7d522bc862e00e5175d01a4e91f01935df37673a503"
    sha256 cellar: :any,                 x86_64_linux:  "ddae72b1e2eb3dab3693036df2afb71709d46fa20e59bc85b447f9687d19003a"
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
