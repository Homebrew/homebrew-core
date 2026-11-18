class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.17.0",
      revision: "34224ea06362074bac977ffc4d777fda5e4f1025"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c36845264033bad7396eac789fee1e17cc85aee4d18c654c51c2dd18f272ff5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35ce67305ae26325af8293ee91de65f4b20abafc8961274fef04866d2a26efdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2aca8e9f7663e32dc14233228e184f1e333844f068d9842c034e29c79be187cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4bafaf82ac9d16bbe7aecb1968f737d89ff38abfbbd73fce8febcb9e42fbfb4"
    sha256 cellar: :any,                 x86_64_linux:      "582373cb119f374939494d59f1dd8008cab05af4ca2a2fb9853f49245113b812"
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
