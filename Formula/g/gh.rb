class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "1a11c1c44e60ac823b2d11d52abc8763648f560cb502b482df1a2da3a565dc47"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cdc9eeb7e6701093f39874a55be4536a09b16fbb8905ffda530c50dc16e9386"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ad7d17313348bef4040bb755f592bfcc7bdc8e0b093ed2cbfb6f3e84e0c246a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91b5857dfba8d6719dcab3018ca1f3d9e8f41797fae79d71aabde08719c07a2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "03d1079bffbd9e7f8f50c9e96629ace9666594a908f97b1334164a1982e01d1c"
    sha256 cellar: :any_skip_relocation, ventura:        "8f75c2d9ebb051df4048b9227990f1c855f480663db0b3a9319d234767e0bb58"
    sha256 cellar: :any_skip_relocation, monterey:       "ff8f73884026b4218b027e73c563334cbb8fba11fa8f582c821e6b2cf0e9dbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c03a9c1f1427fe22197fa991f99abaa091472fc2f318f5a470c6408425b61d"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
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
