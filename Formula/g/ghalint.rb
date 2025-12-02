class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "d6b8846a9770cb2cf41d3bc94ebc08cfd11db0f5d5c3f8c66fea933461bd4053"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b204924b2a85500f881e06bb3196484c381d965e3cd72357b44618230a6bb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed279b0a5822563dd39b43662ac04497b50fed43b3e137d2d65cde5fb968596c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed279b0a5822563dd39b43662ac04497b50fed43b3e137d2d65cde5fb968596c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed279b0a5822563dd39b43662ac04497b50fed43b3e137d2d65cde5fb968596c"
    sha256 cellar: :any_skip_relocation, sonoma:        "48e974049a4e67d70875206faec08ee32983da211af681f1008f23a38babe33a"
    sha256 cellar: :any_skip_relocation, ventura:       "48e974049a4e67d70875206faec08ee32983da211af681f1008f23a38babe33a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877bfb07a484a7c272388915fea67f151cefef8de6be1d17ace20aba9c74627e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de425404f1ad3945363738fa2ec547f0b9a1e8fd5501e7e29b3f595edd015eb3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghalint"
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
