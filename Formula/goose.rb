class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/v3.13.1.tar.gz"
  sha256 "ca4dfb67810db9f72ac772743a000a0b65eb5951f849741a161b739b2e7600a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "633f1280eba47dc5ea7fe0427696eb80bf417319823100c3d478b775133942c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c84788e41abc64bd390b3ce4a1827f7f2eabe4372a55f75e79d932978f8fa381"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6c55528a731d0c73dc2fd696ec11993e4f8d87ac77635fdd094aac529fab76c"
    sha256 cellar: :any_skip_relocation, ventura:        "2420732b10487e6f83fb1c45eaa190ecd1e4ec234f38318413247795eea0fc61"
    sha256 cellar: :any_skip_relocation, monterey:       "1008dde7910cd7707fd5aef5dd5a908bd3992d34e2960206c14ccd37bd2df2b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "db97805ab56040bdbbb1e42dfdcb4dea74b7bc4fee2175b1297b5853c93f3b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d1b4e0c640bccecdd70492f8b67d0d07fac49da6ce600da76b655b8141d0db"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
