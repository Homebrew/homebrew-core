class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.22.0",
      revision: "1aaf433cdc121e499ffad2f278ef7b373c07c2f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87876e5f9da88ea16acad18f9f58efa4ad64fd00b8f252dca5ae270f73f624b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b8b8d86aa48cfbd2f77b49abbd09fad512ca881ec03e72946c53cd924aa84fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf2cbc362aaa788f0b0a5418508cda662c59bda335c22eec38f5cd5baf4d2c0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c64486f39db12e0efc7c7c1e5fcf1b23b58d9849af9d11744d95133547ce83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a92b75974272f25f52c6097b8b60a4bedca28033123f306aba971dd992faa03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d06a75b93d2a339990b385ea54adbf34faa6d1a33630d2f354c918496f31dca"
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
