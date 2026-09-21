class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.7.tar.gz"
  sha256 "39224c6cb9deaf19446cec8c373979ade1efd02d94002af2cd4906b232e7f9e9"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b771f915034e7300b65744e37f389b1b29437a5ff139d37d6cd3f12ca5a26f19"
    sha256 cellar: :any, arm64_tahoe:       "4f8d89b4f836601455467d21fe23e25b67cf797d6db7f9fa42199a6a44d5653a"
    sha256 cellar: :any, arm64_sequoia:     "10d230c1b6540de4b3c1768f11a502175f999dbe2643c1a28c0a59e6bb79be51"
    sha256 cellar: :any, arm64_linux:       "f8c82e3734c98a965d17eb23060b5f3f8076a75341ff459b949f34c00e81455b"
    sha256 cellar: :any, x86_64_linux:      "776f90b3cab7a14e8e118ac2590c69d48e343581d8c489bcde87ad34207d50c9"
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
