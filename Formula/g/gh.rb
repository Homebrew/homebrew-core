class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.75.0.tar.gz"
  sha256 "a99fce70ccb8e0a311a504eda0cfd24e23431e158bf136d81ac7ad25f0431597"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d1cb36d01b6bc0dc765c80d0ab9dff0e26c176bae7b26a2f4bcdc02c3af646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d1cb36d01b6bc0dc765c80d0ab9dff0e26c176bae7b26a2f4bcdc02c3af646"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4d1cb36d01b6bc0dc765c80d0ab9dff0e26c176bae7b26a2f4bcdc02c3af646"
    sha256 cellar: :any_skip_relocation, sonoma:        "78a6877fad9e8813d130fae384a2b868408a9d2ddf9aa203910ea3020dd67b7e"
    sha256 cellar: :any_skip_relocation, ventura:       "5c5e76ca78ad78de1c784fb893fb25cdec9dfcf50f23afaaac5072e98222f066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e010e955a02836a96a692f587acbc55a44ee58e8a267615ad44a76731c8e674"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => "-s -w",
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
