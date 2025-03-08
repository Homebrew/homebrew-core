class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "0022aba12f9532e5340940e20ebae65b1ff0929cc1c9ccbc1633d129d7971b69"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c2e7180b8c33604091a695758f1543e75dbe7b53d66b1e8d6b2de391caf719b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ec488a138b7ec98cafdf29358f40bffdc1072efc162daa905dfa362437bc1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3bd000b3edace043d29240d066703f99e6e2515736f2a31afe44016cb4388af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8e053643de1c6b9efb0f2032d2cf785340c780b26c3cea44245069be87b6b79"
    sha256 cellar: :any_skip_relocation, ventura:       "0ea3281e3400cd91eb2c14786157203ab347dee5d9417d3bfba612c61a69a387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd2e635a9faede77dede2fbe8035837dfa47aad7f81b2d51da6100a758879bf"
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
