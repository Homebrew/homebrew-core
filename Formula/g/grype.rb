class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "9e08267666f693b65fe793f83c3af8adf94d40a53b75538f72e32c5b3d456443"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d889a2d2dd913a78a9332313e31c6e5c737a17ead191dda87b21a967330f1e2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6be281fb15b1df710176eeebd03de229d06762a24eb5e74693d601cc9d86b00b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b98d1d7f6c1c5a6dd81280ae22d52f1af385f3a658bda04c996bf5d0a85195d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7adccbfa7fd5a39feca8863d7de79f7293708f1b342d8edb96d8ebf1c09744e7"
    sha256 cellar: :any_skip_relocation, ventura:        "d293f2febd2cfba28c1332fd919f5d914613dfd6e2faac80ae740c7c3d8cfab3"
    sha256 cellar: :any_skip_relocation, monterey:       "63410f5f867de8f502c1d56f8adac7741ddb4a8fb3a9802df97736919e60364a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f0b7b060fcf607b382c2b08d708a1c819cfd05ba6a2708c3449c94f93fa882"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
