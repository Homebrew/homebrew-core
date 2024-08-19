class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "eedac958431876cebe243925dc354b0c21915d1bc84c5678a8073f0ec91d6a4c"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87fd5458d122633c7df0868da975439dab8df13d53ed8089b4ebc20d602d7e9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67110a2e0b88b929fd19e5f96de64664c8bae12d6e07c0bf5a17a89a1225a844"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa9727f337894861739bf27dcb5a6234d560e5fc8fa25311b7e1d304b02f1329"
    sha256 cellar: :any_skip_relocation, sonoma:         "02f5f1a4a95c0007e5726e63b2efe4b10ebdcaccd203d160c026d1b3726fcaf1"
    sha256 cellar: :any_skip_relocation, ventura:        "16949a188a19f9fdd6580ede3d6b8b5668ec56f8e0e21adfd02bd61f47986094"
    sha256 cellar: :any_skip_relocation, monterey:       "0a42fcf5b41349cfb432925c4812adfecfecf9e5ac5e394e89abed75de030c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb758d55cdccd4c5a61d3665f7ebfdfd05d8ef3224b4cd282fe6e455b0b0d8dc"
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
