class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.3.8.tar.gz"
  sha256 "e03e36778ff9736882e52c43c19da8888443c9130cafd30a3305e42cbfb86467"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3e01d93ef9ed36c9dd72e983e7ae04fb81acb306e33293cfcddd257f8f9856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a3b50ba311850b56646a220b9097d1c499a8b911925fcb99fd03f56f2676d3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e71078a57eeb7ae1cb39a51b5472fbae5e99088c29ecb30add0a10e6d871f25"
    sha256 cellar: :any_skip_relocation, sonoma:        "2221f8e6fc68e0f25c85bdbd3235730c5e80cbb5c0e889ea3554489f6068b0b5"
    sha256 cellar: :any_skip_relocation, ventura:       "7d385af24386c9466c5b97d4c8da53902f2dfe2c5ceea1764bff2953251f9930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d86f83a39b60b0e1d1acc1060b722f9d8028462d4335685fceef8686cfdcff"
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
