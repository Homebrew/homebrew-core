class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ccd597e0f943295a5303125342b96913f8fe3b71676bde4113230ae38536d47b"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa37743a6a24e5b33dde01dbaddd0a3e0cfd7d974eba0b0d127813ebbb3a4f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa37743a6a24e5b33dde01dbaddd0a3e0cfd7d974eba0b0d127813ebbb3a4f62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa37743a6a24e5b33dde01dbaddd0a3e0cfd7d974eba0b0d127813ebbb3a4f62"
    sha256 cellar: :any_skip_relocation, sonoma:        "86c0b669bdb3c8436d5cbf6f2e8e9002370c185478f35296a72232e54788225f"
    sha256 cellar: :any_skip_relocation, ventura:       "86c0b669bdb3c8436d5cbf6f2e8e9002370c185478f35296a72232e54788225f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd24e1973f10c61e00f398f5d1356eb6f85addda261a107f4afaa6df56f7e90f"
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
