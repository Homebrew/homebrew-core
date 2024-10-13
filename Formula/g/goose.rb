class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.22.1.tar.gz"
  sha256 "fc62967a9e4c1d94ce7cf706b727f5af622d004ebb6a6fd73e94b489fb2efe28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d59a515c55392ca7b40b94018ad95ae61332c63e97b2db567243db90b3038d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0cc4d2f156e35028cc86af4d973dd17eb16a9becccfa4c9c4d8c03edd8c180f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d447fa19b49d72b9bea260d6d2c1b685c54910194359bbcd18baadd2d7a51e9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fea0894276eba28727508487c0dde32d4997320d0072733e072bc4e72d4a0144"
    sha256 cellar: :any_skip_relocation, ventura:       "95bc713edd46cc6a19f51f65a93bad6a7b9502f94349f53030e117c8c8a78856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa3e726cec91e14d50c2a87a7653c042468ec6b7dc6923851bb56fd90f71bc6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
