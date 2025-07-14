class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.95.0.tar.gz"
  sha256 "25869b1df827141d7c1e7eaac2ea8e817bf4a6397eabb620d59855d81a3e90a2"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2eecd2ed291d9ac1bb969bc99ebd048dc552006431840b843ab7ab88b0c3c29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273a86b4154b43441b00aad573d42c28b21a27a8a1502fe2a2d4db90883e4f4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb6fbda1b6c5e9f04bae0bfde92ed09f7f61d7d15ccabb3ebfdc4934c805aec7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7cac6b7f565fef8766b61fadaafc37a62ac817be50ce44ce2fb11ab69989d08"
    sha256 cellar: :any_skip_relocation, ventura:       "63e41fd77e4992ca6a58953754d97a651a48a8a1846bcfb2c77897d1ba954afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5917aaf937fa4861c1152d284a2cff6b150e483083ac7ff2dbbaa898ce5f52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1c5cf8a4dd4112f2f74ebcadfde6ccd384fb4cc30372af28e39674c48dde13e"
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
