class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "58269ab6ab93a4b4e0a773fd62efae5f1aefc74fc6bdfcf0fdf5dbce75998146"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33741cd5535e5df83837809763c34247100839c73f967dd43a71f548284332e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6252bf6c1f0745036c4ee99196b3023a2c80339cb7214468561a224b598c2f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d3dadc00214be3d6a5abd4992fc889f181d9c60b543c424d276267cca61433"
    sha256 cellar: :any_skip_relocation, big_sur:        "49a6874f40bc0bda258a81ff83071f0bdfe53bc9b9a6c86cf790809ac1c3dd8b"
    sha256 cellar: :any_skip_relocation, catalina:       "91b519e5eb2342565de2543631e19e7673d27391cc775ca3277cbc77d01dadb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2d43e9e604dde1814874b9db407f0a498b75e01968ad290d45529a34b71ec0"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
