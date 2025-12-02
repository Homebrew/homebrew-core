class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.22.2",
      revision: "e456f78fa2d15b102988eee1025a2451eeaa3ebf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b4149d45df7bc40e7c4941edc9d3354c44987e207d36d7f8d13073478efb42b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3960c2e72fd6bbb15bbf5780e336b99b026ca7c202196166ebd8782e3cd6b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e44a4e59642e2f6b54ef263805213f591e0ff53fbf805cee23cc89009252cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa24fd99069d654c4cbc3bba664a91bc05729ca7276872305233562bbb2fb0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00605e29af12dee104973f7e613b4996a21d5cc3b15037d5126c8ea648b67527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34b9e3a2dd288aeb81118cd83a6a7030f0478248a5ab59d1fc3d24e544b8c6a"
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
