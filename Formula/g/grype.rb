class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.108.0.tar.gz"
  sha256 "831a9d2e10e43c42974b21364f2f9bc29535d7c447f5ab6677790aa09d9c8d14"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd0d85b1843f4a3d065f0f714e88ac84f1532d9b8e6e1b70aefeef01425b474e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4332627b18d9740a011e87f3af19f6c0f19b7a1cd6ba53c645165fb0b383d3bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476779282ef3657f746da29888c590f2ee88a769861e2d44270614bf8bd32c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fcfb20d402b3ffbf50db2bc1e0736309391eb39d3083399dbc4e3d5ae86a196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13026c642679a9f09ca065079a9b24ed20fa0f130d839eeb088750ce7da98cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af47235184769b03b0f96d05fdc9fe273ea0cd6f08f097ce881e9be51e76156"
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
