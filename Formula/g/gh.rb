class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.98.0.tar.gz"
  sha256 "abada9e8b550547ac93f99250f3ad4d90ad623fa245cb54cb058f78030a6a5f6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a726b1b74d9ec5d18cdd68df30b1eb1f4d0c2ceff1a93d42f227d9501cc92c07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "768217b119ea7680432b1f85ea0dbe1adc56d96ec99cec417fdc02119ae16e0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "334054269a855a8c0a6eb39ceb2e43876c2f83b19f9274f2622195e8994fb80e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2b15b8c79586e7332309c65323d15bbefb546904edf20e732cbb3d076c43684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04fbf1a48ed426df37de4071b395d740c2340ff93123ebbbe96fa8a98f3e3d4f"
    sha256 cellar: :any,                 x86_64_linux:  "4ceee03c3936c0dda1ec1bf2e69501f75b4861b333d89d9207c4194febecebd4"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

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
