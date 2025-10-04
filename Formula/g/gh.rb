class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.81.0.tar.gz"
  sha256 "11550fd0e06043f29d03fd973dd67cb77b2fee462a76084e0812c2099c6689dc"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d419fc9cfecf80e6c91bdcb2ee980677c7d7cddecc64d3e5f8170b77e8ccf42f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d419fc9cfecf80e6c91bdcb2ee980677c7d7cddecc64d3e5f8170b77e8ccf42f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d419fc9cfecf80e6c91bdcb2ee980677c7d7cddecc64d3e5f8170b77e8ccf42f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f333dc9fe86a10f243233b5a46ff47af79b36a78b45deff3f7b74c75391e955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c534eb3c4d43e44b8dd8fb323a79a7551ba2cf4e1c2982ffc373cb15fa9d73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759bc5041dd266a59e63c8cd5ccf5c5e80e72ac5bc558bbf7f356a6bfae51c90"
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

    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
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
  end
end
