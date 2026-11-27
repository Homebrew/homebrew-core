class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.20.0",
      revision: "e596bf276e034ee7b1ea7ee8c5ec07763381e45e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "98fa88626e26ccc8ccec1a15287f2ea803da2723c974713357f5b6c295528a8c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15e59815236f5925f814d5b749f7f53d29526304fa85672a88039b02f22caf8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4581b582b1da03caa90ddb85faccd1b134004077deca4903c3666c5feae9476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb3ff36e48430731d395aa7b940ea2843ca06f6be0bc67a50f0a7dfbda616e66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04f95d67f1f487e85a683ba8faa1d71bc39288919f572c7f04e8b38ecfca6c04"
    sha256 cellar: :any,                 x86_64_linux:      "d62c16072604924e5486fb1e7a4a9ad32559f3e9691e9f320e8f6852a8159ad9"
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
