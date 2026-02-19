class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "faeaa04092a4d26c39b6ac7b5ecded5d9c970df35654a3b873d69e45e038fe1a"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d76a40b66cef3c662e3640e21831608994afd975421cdcade724f9c2a91cfdf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76a40b66cef3c662e3640e21831608994afd975421cdcade724f9c2a91cfdf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76a40b66cef3c662e3640e21831608994afd975421cdcade724f9c2a91cfdf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "59af90a6c1a219d9c22e362f1c4247e6c86d467bc1fca2f1b0e6863bc40d8b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc504c542ae7a9a1760a766f97dec113404448ac12f60bb816fe01063928db19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4279ba059a6609ea05324b5a7c05a8e7aab91f5b2a87a9c8b1f29aaf934b337"
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
