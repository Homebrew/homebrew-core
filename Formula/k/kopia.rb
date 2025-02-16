class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.19.0",
      revision: "1f8f728c4133d4f419df93e58a5b54c3bf9c75e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9430645f7e2915c3aa6a0016dd5e37c5b42bdaec0f7657653665c6802e8c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed432634abf977bbd40485a564fc89502e10b8d499264c5a40ca5de3d3fe462"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53ec2d045ae77a30f91ac81b7c2cba5a36a4a98e90a2cb1b7d990ec43f8a1414"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d3710d308a6ddf5e3684454455da513fd6539d9ba05f47218e83ee45fad26f"
    sha256 cellar: :any_skip_relocation, ventura:       "60c61bf2914531a25a8be8342902d00bce084c5e5f45e1d19ac529392502e65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604ba9ec6d6e0c540946fb571881cdfec3572c6851945039b471a79455e52b94"
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
    assert_path_exists testpath/"repo/kopia.repository.f"
    system bin/"kopia", "snapshot", "create", testpath/"testdir"
    system bin/"kopia", "snapshot", "list"
    system bin/"kopia", "repository", "disconnect"
  end
end
