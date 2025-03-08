class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.68.1.tar.gz"
  sha256 "520ab7ca5eda31af4aab717e1f9bc65497cdc23a46f71dab56d47513e00c7b82"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00a9df8ae9422099439e04b96d53384f36a9434edfe4ac261216289cdd1209e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a9df8ae9422099439e04b96d53384f36a9434edfe4ac261216289cdd1209e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00a9df8ae9422099439e04b96d53384f36a9434edfe4ac261216289cdd1209e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccdf77ec556e20be29248756124e5d1ab1dfeaf1364d4943e749e8e2c36e60b7"
    sha256 cellar: :any_skip_relocation, ventura:       "bdc0d783c276683d4d283924095e169015b6782abecb3f9a15097aaa42e160c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6091c1142f8a4e7b19973025da6fe4c7ce70ec902e306768460ef425666f0f3f"
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
      "GH_VERSION" => gh_version,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
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
