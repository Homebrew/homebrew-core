class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "a266fe8575c0e061b987920c1831a15f71bf0036a8729a5ebb93c2fb0164899c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ae24b7f4a10249212370f0028103a72c235910258b28ddf20aca48aa9d95cae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8019604f792cceb8a24bfdba13458457fb98a889144b29fc51e2df022fe4865c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba8652a45f996be2c6ee389e567d7719624c45a3e3a97b7bed55f64d20548cc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "751efd50f8ec1f0fb66696c12b5d48b266e624d421d57f85f35cb804da863c61"
    sha256 cellar: :any,                 x86_64_linux:      "27b7df78ab30d0a99ebf05f0f0c0b8191935ddacdc901c6225ec162ef7753d53"
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
