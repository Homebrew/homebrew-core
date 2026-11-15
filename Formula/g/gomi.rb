class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "f36a6f3149c1fba46a8785dccd6deb8d45a5aee180a6fc851d6fd9c4234ae1d2"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9265e068d4230b86a02f58faacc32f39d94248fb0579cd8d8b2b3117622b5b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9265e068d4230b86a02f58faacc32f39d94248fb0579cd8d8b2b3117622b5b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9265e068d4230b86a02f58faacc32f39d94248fb0579cd8d8b2b3117622b5b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d964b6cad10d4b665557eef37d4ed9c0f22f2a9b57a9bea5a2801778cda55a4"
    sha256 cellar: :any,                 x86_64_linux:      "57b578ce1ef478767012a4eb5149338bd19baecfbc88bb91e1fbbc1454f72c17"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["TMPDIR"] = testpath

    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end
