class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.7.tar.gz"
  sha256 "ed324328d19c710a5c8d03a04e5ee13dd821765205afd75cf5320440f72d9921"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5a2f484ffab77d59be8701cb5f1648979793cc4c455e891bbf25a8f7cc8a9884"
    sha256 cellar: :any, arm64_sequoia: "60f0ef43c11bf07fcf31e9d352a6f0f572df51a0f19ae36f06a1dba359f468b9"
    sha256 cellar: :any, arm64_sonoma:  "7e2e18c0c521823715db82343b9a356c87a51779eb902bb0b2ed7302e29a78e9"
    sha256 cellar: :any, sonoma:        "a2fcc614b86221c92c48e4bc3848f1f842b80838cb33a0582b0d0e64a8d1cb03"
    sha256 cellar: :any, arm64_linux:   "9f95fbf89fbdf1a5e92ddad9920ace5aa12259bcea2d724acab8e6625eed6a89"
    sha256 cellar: :any, x86_64_linux:  "228acaf1b1d26cb1d90d319d967b8df4e547b6b07ae0000e673d6f517277bbe5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", "--bin", "datadog-static-analyzer",
                               "--bin", "datadog-static-analyzer-git-hook",
                               *std_cargo_args(path: "crates/bins")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datadog-static-analyzer --version")

    (testpath/"test.py").write "import os\n"
    (testpath/"static-analysis.datadog.yml").write <<~YAML
      rulesets:
        - python-best-practices
    YAML
    output = shell_output("#{bin}/datadog-static-analyzer -i #{testpath} -f sarif " \
                          "-o #{testpath}/output.sarif")
    assert_match "Static Analysis Summary", output
    assert_path_exists testpath/"output.sarif"
  end
end
