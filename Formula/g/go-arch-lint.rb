class GoArchLint < Formula
  desc "Architecture linter for Go projects"
  homepage "https://github.com/fe3dback/go-arch-lint"
  url "https://github.com/fe3dback/go-arch-lint/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "cff6365a8a13b38e4bbf6c4ac3744b576e19708b70e2e0079abf5ff91cc9a4ba"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "go-arch-lint", shell_output("#{bin}/go-arch-lint --help")
  end
end
