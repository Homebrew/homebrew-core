class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "72670806967ecb63bf516b3e36635cdbbccff7a1f648782996b6e614f06565c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc904bcc85efab494238756c0cc09bc9afcb011006c77c185db0851db18302e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc904bcc85efab494238756c0cc09bc9afcb011006c77c185db0851db18302e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc904bcc85efab494238756c0cc09bc9afcb011006c77c185db0851db18302e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "55212608af5d376981fd87232f8558d9640636ba83bc39ca05ff9ff24d0f53cd"
    sha256 cellar: :any_skip_relocation, ventura:       "55212608af5d376981fd87232f8558d9640636ba83bc39ca05ff9ff24d0f53cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fe29135622fbeb235f21de31bf5c7879ea3441eee7a7e8df9c5dcaf5100daa3"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
