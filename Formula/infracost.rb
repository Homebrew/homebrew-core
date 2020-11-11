class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.2.tar.gz"
  sha256 "481dc0589ecea67a8ea706bceff935bea6886b55062b485e8c0ef08f7e123281"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "546242ad3b42048aea9a1160178893ae52d11229df0fd4623f29a869b23e6c11" => :catalina
    sha256 "2adb2267baea024818e1f708cf61881a9d38dc86ccc6b99338ff0569ad84f5c4" => :mojave
    sha256 "354f00aa5cbf5fcbf5d9851b4c9ea46af84e3bfe76a49a0783abde11ef31f531" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
