class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/refs/tags/v0.0.55.tar.gz"
  sha256 "3e46b2e95725dc0e85816c6c6811cb81ab573147df0e888bb3354642e1286e9f"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0693ca4e1b15f73eb34c1d3102c260eda6a224a2c1465b507b010e22fd180435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0693ca4e1b15f73eb34c1d3102c260eda6a224a2c1465b507b010e22fd180435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0693ca4e1b15f73eb34c1d3102c260eda6a224a2c1465b507b010e22fd180435"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac937f6c7f36311cfab5a1e97dab37b8c0338c1e02c355e0751afbb6fd9033aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f68a3e2e52b57d2b1fe1655277267c139232e69af2c93557b744dfba0f8f889b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76991739d7e07865d25f1e0a11711572e38919a9096095778aaec8d05269b27e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"config.yml").write <<~YAML
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    YAML
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
