class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.9.tar.gz"
  sha256 "20771c833f274a38040964c58f2cea97956a64a44a8b10aa0cca5d215b0e9f19"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "df22bf5451becb1092e748fd547f7afb2ed079138fd50659acad23ae085e64a6"
    sha256 cellar: :any, arm64_tahoe:       "ed448a85f90c9e902b813c1cb7f3997e48a4ee8e7a516b5c2f0e2316832568ed"
    sha256 cellar: :any, arm64_sequoia:     "3066b05a44c2eb46fe5988beb90feb1ddcfaf6fa65db00b389ed21f16ecb7ea2"
    sha256 cellar: :any, arm64_linux:       "24283c25140cabf0471bd85ebb7e0aef886eae26eb2e61dcb9d1ffcaaae4ef65"
    sha256 cellar: :any, x86_64_linux:      "6b067a91a6b28141628d41cb5ec0ebe75916e6fbb4a411c4a3adbc707ad8e9c1"
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
