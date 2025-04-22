class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.91.0.tar.gz"
  sha256 "fe8213049a873c03929bbcdfdc77a9389f4232ab1b63d13589b3d74296c06125"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411a3c30013ca25956c03b044d92d3e595552b19875ce75890279f24715d98e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea9e3b22dc06eae29ca1cfdd487891a32294d381dad4db75b9ea005c8b218595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "529e31640619625f7bf324449d4121f9f704dd265cab51613b636b0514fed593"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f4b04af98850093cf2f20b69c9e76774801cb3f3004ccbaaf34c29d0a382a4"
    sha256 cellar: :any_skip_relocation, ventura:       "e4a4152cd4bb7edaae5d3b3698e59e241acee57e4dae9ef5687eebbce3a43bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f39afbda04b4298376463ef45efd59f08c473aa7a6d971c23f86feabe7993d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945193d5d9132ab49baf5a434b9570df45f98d4c197994ca55ebd699d33093db"
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
