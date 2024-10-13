class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "11f0f78869a93afde4866ff5296af145c7c5b5556075cc43a082b17e055a2db7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11aaada67adf0efc49b90bc525e576dd9743e86831f84c4df01498da991f14f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11aaada67adf0efc49b90bc525e576dd9743e86831f84c4df01498da991f14f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11aaada67adf0efc49b90bc525e576dd9743e86831f84c4df01498da991f14f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d75f9aac1de56b94f47303bc8b41e9f678ad492b3e2608eb8d0bd4eebfa6d7"
    sha256 cellar: :any_skip_relocation, ventura:       "c7d75f9aac1de56b94f47303bc8b41e9f678ad492b3e2608eb8d0bd4eebfa6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daac545ee9c76818b895acbe0843d273bf4980d18c1e900e59c9a2b626e5d7c7"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end
