class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.3.1.tar.gz"
  sha256 "5e5dca830aa5012fa1851513c10c0a5de4d3f38c16a172928b1d8e9dd9c75957"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6f01868e74ff2082b19d5000502206875d86cd54cf5a6c2f503ead46d48a38ac" => :big_sur
    sha256 "ec0ae34ee04b4f9e0ffe813957ae5fd0fd28b895dbb327d0244e97d0e992d87f" => :catalina
    sha256 "924ff3e546d4f0eec09a4dd8679d1a74f99f771a9f00bf0a7b130d2ffd0b0e1a" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GH_VERSION"] = version.to_s
    ENV["GO_LDFLAGS"] = "-s -w"
    system "make", "bin/gh", "manpages"
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
