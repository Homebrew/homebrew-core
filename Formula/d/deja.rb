class Deja < Formula
  desc "Predictive ghost-text autosuggestions for zsh"
  homepage "https://github.com/Giammarco-Ferranti/deja"
  url "https://github.com/Giammarco-Ferranti/deja/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "c122b5556558f87e754398ea1f1b8d0f5276d2249939db487b1b780f616ec1c8"
  license "MIT"
  head "https://github.com/Giammarco-Ferranti/deja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1dea6ae6c577b0cb9967bfbfa134c923f6d169579b797c8bb0f01c2010606b80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b74e26cdf7af28d48241a01b10ec17a5f615e67f117f0b5f8c71c679c3f3bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d87800503cd360d967c9cfdaa5eccd8609380c1047e5b00c4ccf09e43a7bf573"
    sha256 cellar: :any,                 arm64_linux:       "5c2f5b645dc17b75f815768195ec1dfb3460cac18fb4ac1cecba2a44cfd9c75b"
    sha256 cellar: :any,                 x86_64_linux:      "311915b4c74f3f4f61c6fd233c25359a6f3af6a67b6b19755f97ff12857f9690"
  end

  depends_on "go" => :build

  conflicts_with "deja-vu", because: "both install `deja` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/deja"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")

    history = testpath/"zsh_history"
    history.write <<~HISTORY
      : 1757000000:0;git status
      : 1757000001:0;git checkout main
      : 1757000002:0;docker compose up -d
    HISTORY
    assert_match "imported 3 commands",
      shell_output("#{bin}/deja import --file #{history}")

    # `query` falls back to a direct SQLite read when the daemon is not
    # running, so this exercises the importer, store, and fuzzy scorer.
    assert_equal "git checkout main",
      shell_output("#{bin}/deja query --buffer 'git ceckout'").chomp
  end
end
