class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "da3416c766fca5298b2205235b863041eb02dd1a36f517ac3f849a8c167aed3b"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea2bfd4a29c3dc9e8135e478c712423232bcf37dd432df2b6d82feede98d376f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "305862469a7333a38c48780115fe0b3af69541a961615baa750feb1683b242fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a470b0e8fe3028b1f4407b604e269cb7977f3d2c340ea052863a0da132442b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e32e474bce6447d46137aa53cef132dc67dd570b3f10dfbe684397ec191539b"
    sha256 cellar: :any_skip_relocation, ventura:        "37db074270b7d780bdfd4f4749bae2819213b033076fd1fbae8756f02c316564"
    sha256 cellar: :any_skip_relocation, monterey:       "a7b320a2720a37ddbceb13e329f5bb878c764db853be7b2104f15a6ab568a6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47623884025b66fef62f60f84da81176eaf6dec2234651d1736010dece594914"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
