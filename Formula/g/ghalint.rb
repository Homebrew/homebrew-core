class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "937ff5e7d975a3f2630be79e339258eae9fea1d2a42ff9845e0fc67f9ef18d6b"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "560814b4fbcc5a4fad30663658cd85cf9147095afa155a63f63d5f3f7f09259e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "560814b4fbcc5a4fad30663658cd85cf9147095afa155a63f63d5f3f7f09259e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "560814b4fbcc5a4fad30663658cd85cf9147095afa155a63f63d5f3f7f09259e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6795dff625a04bd70ba64b0a4f0714c8b3ab22b24bd597a28cc24d5645f50db6"
    sha256 cellar: :any,                 x86_64_linux:      "365c76e78d5e346bbd4e5950b441fd486a306d860d62a4e85bf5733719a5f36c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
