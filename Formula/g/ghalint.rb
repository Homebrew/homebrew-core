class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "1188047b654a86390d49b776153c1a7b3eddde30ebcc0d024dfab9585785b02b"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc6245ebb383c63ad0be81107c0a6d6082bd049c8733a488ce7f8750fca1a087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc6245ebb383c63ad0be81107c0a6d6082bd049c8733a488ce7f8750fca1a087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc6245ebb383c63ad0be81107c0a6d6082bd049c8733a488ce7f8750fca1a087"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa7695f943362c7bc2c992a4193116a24b4b067eb95748118e4ddb6e4239ba6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ae564117778a881047c0bc57755a117a6e6666e9d63d0a2c1964528f755605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b02ec283b1788992a002e459295dc3c6303f3c3b8f60d1206537c2aefe5bee"
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
