class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.17.0",
      revision: "89c8eb47af2e1d5c1d14fe299a0cf7eaac095abf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8a66cd5ba41a032336a449856bb176e3a6891ea75eb85421ac9ba706d94d5cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5ed85392bb79104cfb3a444ac9fcee57491bd4d5565bc95927bb80235548718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca58ad4ddf8815aa955d467cdca949fbee9b6abcb58152f47be8b0b3dcc76ed1"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc1a24e8bec43cf4589c87679ed25e77f381e881ff88b5836a2d0ed75a79c3f9"
    sha256 cellar: :any_skip_relocation, ventura:        "8cac150b0e0a107ceb551baeb1f6ff3647fa55e5da4f830ad372cf6031733e17"
    sha256 cellar: :any_skip_relocation, monterey:       "9b334aa32577af260852696d3e74f486fe7e9ab9fde509e37115bb7065369410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716fc026d9798abc418eebf156d7c1837bec2dde9c578ab313528a49ed1be85c"
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
