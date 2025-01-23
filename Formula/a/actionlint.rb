class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "237aec651a903bf4e9f9c8eb638da6aa4d89d07c484f45f11cfb89c2dbf277a5"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d94522b3eefa067708c2ffe00f95a3b7ea39180a5399ec2f570f021228fabe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d94522b3eefa067708c2ffe00f95a3b7ea39180a5399ec2f570f021228fabe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d94522b3eefa067708c2ffe00f95a3b7ea39180a5399ec2f570f021228fabe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1059f386ad492562782f7286b73a94c3cdab1a2b52e28ffc2962edd051058b8c"
    sha256 cellar: :any_skip_relocation, ventura:       "1059f386ad492562782f7286b73a94c3cdab1a2b52e28ffc2962edd051058b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04830cca2357b8cb8cf30a297bbbe5e1e347f5c0320ca67f621805e6f4843a87"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "shellcheck"

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionlint --version 2>&1")

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
