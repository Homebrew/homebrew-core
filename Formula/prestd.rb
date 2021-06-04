class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.8.tar.gz"
  sha256 "dac1ecda03b866141ec18d95b35f8c8faef38fc36e3d6f8cee1930f54e6c10a7"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a86541c7882f0d9b67850833ccaaaf410096a9800aa12efc063b04723c8a28a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4a50947520487dbbf46ba8bff98dd8f7c7bde1ce6727475e9c65a9fa9ce3720"
    sha256 cellar: :any_skip_relocation, catalina:      "ac3cea50b2fa14605264ce90485a11dcca772c92456c1b2b7aad359dfcef78ef"
    sha256 cellar: :any_skip_relocation, mojave:        "1145fec603b57b5323f6499812f5aa84151c9d0f519788bfe23758a2d88cfb5e"
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
