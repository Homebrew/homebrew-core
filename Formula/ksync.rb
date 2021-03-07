class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.6",
      revision: "bfb445b179a0405ab4a01b999010010406f425b7"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b8fdaafce04e89be790f15be07240b0ce0baabd5550ce6f625b6177d9fafecd1"
    sha256 cellar: :any_skip_relocation, big_sur:       "e68abf337654f51128a835f8d3c124df880a37a26f2773b0aa09fce74c67d63a"
    sha256 cellar: :any_skip_relocation, catalina:      "68409c1188fc629bb181765961ee9ff645b941400edcea9939d8d7189e7db5dc"
    sha256 cellar: :any_skip_relocation, mojave:        "a4d52a2a59f8b6308ea858f051e8971145b9964c32564a832408e05f6582c23e"
  end

  depends_on "go" => :build

  def install
    # Remove this when upstream provide working go.sum files
    # (i.e. it builds without errors)
    # https://github.com/ksync/ksync/issues/504
    system "go", "mod", "tidy"

    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{Time.now.utc.rfc3339(9)}
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
