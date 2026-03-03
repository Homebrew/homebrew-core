class Lazyworktree < Formula
  desc "Terminal UI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "34ebee924e5b337983eee6cecee47a78e32e0ea20481497ee9632b30a79b1264"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyworktree"

    man1.install "lazyworktree.1"

    generate_completions_from_executable(bin/"lazyworktree", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyworktree --version")
  end
end
