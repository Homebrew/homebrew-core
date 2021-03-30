class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.8.tar.gz"
  sha256 "dac1ecda03b866141ec18d95b35f8c8faef38fc36e3d6f8cee1930f54e6c10a7"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f78d08494ba4e21e12e32fb43dc50064ef939288d32a30ba8797c572b8682447"
    sha256 cellar: :any_skip_relocation, big_sur:       "46f86063875cc783dde53245584d4116a35803885c3264a3e8ae29cb63e11117"
    sha256 cellar: :any_skip_relocation, catalina:      "25187129bb020d5797bbb6af360a87cebd1873ee69941f23e05207894513b4a7"
    sha256 cellar: :any_skip_relocation, mojave:        "ee73987bd4c889342bfd7fc6cd8b059ce7550e13085df3c6e3bf0ba94ed299ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
  end

  test do
    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
