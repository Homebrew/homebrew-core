class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.111.1.tar.gz"
  sha256 "f7d8ff24a729c489cb1356ef539251945679a73c9de704dd6871a2455229c44d"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "072e9e0bab57d7c5f5fa43dae790165cd153877c04bf8ef036810202d67f8e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c08d36c96dfd97b887899daa325d42aca706dedc971f2131336a8a58a3b1566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f83f1ffb1e26f7fc26921cf30f9890be9a8d7abbd8ad72a3a758394c128137a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ea90239012f520e277156b99c833f4c0096a8a57310e9ea72dd58a8556a2c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d70587091d4901750d04c8eb084bd59062b52e109958394c08ee4eba4397e0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251c1bc88449f31d22ae5a480714ef698cf4591e85efdc64c639970d4e8e398a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
