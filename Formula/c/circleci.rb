class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51515",
      revision: "a2e7dd1c5b90822bbc408655ae23b840d8d46ca1"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5aa3d14aa7f3c371ac9209e0616fbfeb38ca5180e72dd0b1ded8f3b8e477ba3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f3a064f58cd67e9c804d10bec8517a552224434f7f4d8768e5f84918a45d75d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cca8147cd9fe8653c5f643ede5446ae3aa666030b99d196048b2c0632d341d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "93d713ba0c119ae062d12e8cdde55af64def177a0d8ffb8c87ee6a7db003a53d"
    sha256 cellar: :any,                 x86_64_linux:      "8c32e3836f1d87d651e34d8e8e5cee869f1016018c4a8bdd9a79053a25d13890"
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
