class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.9.0",
      revision: "87bdeeef312c8d4773c492beecf83cd3c4cd626e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ada98e00aa4d4d8cbbca7372ce21f5e0da940d4e84e89e0a9aa197181db479e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f05a3776c8866342db5572511b452e8d8e6c6ef485963defef68dcdbac583f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70defceb79455ebe33348f90b26f1ce478d44a000b43fb7767fee521adee0a36"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "203761819adfe7dc5541c105e6ec12ef9012cd1868eb952cf840bbf15dd9c22c"
    sha256 cellar: :any,                 x86_64_linux:      "4c293495dc37e2214ab980e187b94f0ccaa0cb470ccc2598ec74dd3990d4c643"
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
