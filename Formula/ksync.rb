class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.6",
      revision: "a63f23dba397a540cca9cbde5001afa5cbd8b2ae"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e0e5dce990e687f5d19f30eff1dddf44430bfdcaa63da2389183436f6426833f"
    sha256 cellar: :any_skip_relocation, catalina: "3d5ec6bf44c875d29d501b8ca96f7ca49aab9d749a8bad3a3cb967eea6883487"
    sha256 cellar: :any_skip_relocation, mojave:   "03b1cda4ab1cb87932e019a009e8a46f06cfc180ecefd6cb574aa1d8e11ab751"
  end

  depends_on "go" => :build

  def install
    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{Utils.safe_popen_read("date", "+%Y%m%dT%H%M%S").chomp}
      -X #{project}/pkg/ksync.VersionString=Homebrew
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "#{project}/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end
