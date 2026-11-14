class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.15.0",
      revision: "75e476473fad4133cfea6e53988ad2ccb9cd37c0"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bce82d5610096e55c4b4ac04f2f5d85ba2e4e323632fbb533679cddcb44d8bcf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f6d22e17b90731b13853815d0338cae65a74e31ab5f5bf0b4ba35229e419102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "831ec965baf77b131867bbf7335c18fa26e0ac19efa1ff22f3a7296834d29e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a65f37beb55511b68bc4585713c80d63a0962c73f4e8aba8bab0273802e1dd52"
    sha256 cellar: :any,                 x86_64_linux:      "ba132630d01942cab895c0361d64ce777cbc76409836855e4c4342fb899d1668"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
