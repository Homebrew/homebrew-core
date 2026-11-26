class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.106.0.tar.gz"
  sha256 "ffbaa7f4ba49ca7755ad29c4c92ae28046a969c47476a2218e3ae30183f81346"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "438a59258125ab9b576caf90bd171051ddaa47e8302d8a9975008796e9677e43"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb4eb44d79115b24df302966df64e7afa745ffb52578eca62739806d9c35fe2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a48c54330699e97d98fe744d58520c719150a2238c2e0400625499073736ffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc1d4443228406de79e1f86d0feec5900b395656e4e446778807ed9a1324d0cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3718dc635f2ee8d16d05501c97e36d9ffa08f3341da2d0ee5245db75d18144d2"
    sha256 cellar: :any,                 x86_64_linux:      "4ab492a1ed8df59dfe441677eaf80207a8f3f8449d1987206aa0fbbfaf6bdc8b"
  end

  depends_on "go" => :build

  allow_network_access! :build

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]
    ENV.prepend_path "PATH", buildpath/"bin"

    with_env(
      "GH_VERSION"   => gh_version,
      "GOBIN"        => buildpath/"bin",
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "licenses"
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install buildpath.glob("share/man/man1/gh*.1")
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
    assert_match "GitHub CLI third-party dependencies", shell_output("#{bin}/gh licenses")
  end
end
