class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.121.0.tar.gz"
  sha256 "87244bc41b3fbd596d12f31f2f0e335d36c1059662f27baa31036584e427d169"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dec7e9bee99194441ee7e9681dac649c842e519566bf29332398365e3451428f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cf299e4a173dd3401f77062a91152003017159c858c09d9b62bcc6dca05c286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "741930d6b161fa84e777d979b38d686066eb7ecb7aad0afec55f892797baf57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b97bcb2c8c6209d5587bbeb6d61f8b56ad798d3784e7755d20c812ecad53b7f4"
    sha256 cellar: :any,                 x86_64_linux:      "203545344c2b495ecb5090d077cbc2c33522aefbe91ca4c6be677842c757930c"
  end

  depends_on "go" => :build

  # `test do` block downloads the vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
