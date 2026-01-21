class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "bd3c22fc58ba5f4a1546aceb373aaa1c609b902a874d75688be700bc2fd9c09d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34563846ca0b2ecfa8f93b3731ef87cf701f3d3d9dec3b65d4a159b7a9cb1a15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34563846ca0b2ecfa8f93b3731ef87cf701f3d3d9dec3b65d4a159b7a9cb1a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34563846ca0b2ecfa8f93b3731ef87cf701f3d3d9dec3b65d4a159b7a9cb1a15"
    sha256 cellar: :any_skip_relocation, sonoma:        "3698d68a7c3cc1d34dbeb90c16ec5fd64a6899b8a21ad812609ff071bba79efd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf871746002efddf8f508268403acc60384cb45a9bcaecbf698db0a821cf16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43910da32f7c8270e8c1f9a2026616f5d89fd86f1e70c331e98620fb7c20bbfd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghalint"

    generate_completions_from_executable(bin/"ghalint", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghalint version")

    (testpath/".github/workflows/test.yml").write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/ghalint run .github/workflows/test.yml 2>&1", 1)
    assert_match "job should have permissions", output
  end
end
