class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.121.1.tar.gz"
  sha256 "e3037387939d3230531571d712baf180a96d0ace60042c2f7e15e6b6e7a3f127"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8295a745f1ff9184ae6e3ff462f41c499addfb954aea74bd7fb767a5d8ab419f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d77ce08d3cea686e500b523fb6018bc5bec0befa340edb43c42b1b67d5da1370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b52de646d35fbab2c9f4fe2d69527ed53aa71ab10a6605add40dfbb547733f59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f010e6f3b590222ad7a7921f872a2585ea6fd0f1c692f03b2167c67e251266e8"
    sha256 cellar: :any,                 x86_64_linux:      "cc32bfdbfe84f487ff20a52446fa5dd807d25134030ed6d77ea6014760a81105"
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
