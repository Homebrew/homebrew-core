class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "1a4d0eabf47a4ee8706726c7d83540ab5c4ad319e5bca5c983c20f70be802575"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e2cc05f174bd4d92f95e85e3c1e831a8a9d648aa46928aca668b728359d9bba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e7da58d33029e9fea888f7638a744cc4dfdc8972d9692f1b19ad00bb65a64b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf536363ba10a1692b720f598cfb6bbb77b239dbe7e8a91dfecc9bc5c4144813"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c70d2c84a8f84fdce22558ca79bb981385f0ad982203c7a482dcd35b372572"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea775d99260c25fd4254ea8094dec286ca35a95b7cdbebb0e8363cceb5cd6aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad9fba4615506120fd4b0b583968be894213fd70a7c7a34ad7f3770e71a51ce"
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
