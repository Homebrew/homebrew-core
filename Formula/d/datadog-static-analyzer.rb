class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.12.tar.gz"
  sha256 "a9fd3a075b2cb3e2a0a39c8520943ddd295e0005418f4403c065062f44a96e1d"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "02a22025d21b2a052559cca048547f87ffdf9af0e8ad5c502ba488b0b70fb263"
    sha256 cellar: :any, arm64_tahoe:       "e8651c1f08d3c02d02e121cab14d6f7f63fbe953467af32785b18ffa16f08595"
    sha256 cellar: :any, arm64_sequoia:     "f493c002f91cdb4b79a7251d349776d9c4635f8134e1575777d006d871d31b35"
    sha256 cellar: :any, arm64_linux:       "b2e7a18d81472d778f0e0cda63a591bd76f3bb9475a9c3423694afb1a13ca74b"
    sha256 cellar: :any, x86_64_linux:      "1534594ef848d07720d59e1dfdc6d2311b43f52f914b78c96477ca3471550392"
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
