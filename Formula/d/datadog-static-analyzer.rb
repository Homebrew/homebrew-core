class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.11.tar.gz"
  sha256 "4688f21c61e52dd157e53fda8fe57354a9b255a845fdd44acbe20082bfb67363"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a52bc47652a205b446741463eb93680e27a6ee68b0885f3bbea03c6c6f5a93c1"
    sha256 cellar: :any, arm64_tahoe:       "25bccd3b3f6fa2a64f1276720d7abb57f955d1fa07dfc0917262efcca95d929b"
    sha256 cellar: :any, arm64_sequoia:     "5ec715d164911c7d676d3e2e339bd8b2ca94bd52c56b5a3202adf8aa9fa00242"
    sha256 cellar: :any, arm64_linux:       "96f98b96a107780caa50bdd1708bf7ef68c527f1bc975661272ba5b042d2b451"
    sha256 cellar: :any, x86_64_linux:      "ae5b4ff710e4549c6b36cebd9c0e65699d321f61cd7fa147233e1fbafe141493"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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
