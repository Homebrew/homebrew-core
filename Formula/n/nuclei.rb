class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "caa622327dc8661e032b44bb1174e3df1858de8cb33086737330deec9f126549"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "539cceaeab3b35075c64f42f5145f7dbd5bea43480363040f0bb72e3f95a0a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "360aff1e4ae34e2d5cc27ba683cc26a42394553ca4c10efdce72b66f37169be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebabbf88d0f78cc2e132dbc1d1820405f417094d0a34f396a90824ef022ef693"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c4c6fb14cbf4df70f24b88f8d4a962e01a3b32ba74ed716dbfa12e38f191184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4734ff468e630a73c91e7960e519d7bd633ebfb818a7677147739edf0d17e117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f16b70f29b186fdd6bbb18e6f16668d9be61dc2117a95639b02a7e1a50ae1b"
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
