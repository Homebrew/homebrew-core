class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "e99290c7eab2a1328cdbafbf6d53bc8ce693fb201dc201224fffc5b2f4b9aaaf"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f64e8cf677e856c379e570f68a30b3d846d80903639e45ea530f1dcc370643a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1d8eb2432977dfc00942b2a08511ef22dc7e9b8622d7b77b30c56b3f42b0efc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddda2cbe53b6b279154192556f383a01ed545e8193a21de540194074073d77fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba63c632c3a9d0c76ba87c4c16133e8484982070391d511f66d21346e0233962"
    sha256 cellar: :any_skip_relocation, ventura:        "e33ddc71e6440ab62e1fc211a16e8909bf3f7ed4ceb762bec801d62e1c49c0bf"
    sha256 cellar: :any_skip_relocation, monterey:       "8b739a6d9857eafd5961f378f36bfb198b4c31988ae178c98573a4c7f2dd1e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1016805e5647e902b041d278e6b69da3a393fb173e211d6d602fad20b06d3f45"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output "#{bin}/cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
