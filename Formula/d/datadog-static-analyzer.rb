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
    sha256 cellar: :any, arm64_golden_gate: "c491efdfe4bc612ed936a06e1a21166c330e7a63ed39f4a1a070a37c4b3e3ba8"
    sha256 cellar: :any, arm64_tahoe:       "5112bfa3a19995ef0e24bb8bfc20f73938c7683b4d78c0864dce2ad64b48ce63"
    sha256 cellar: :any, arm64_sequoia:     "0dd065ec9fc49f2c4a3ccbba81e38ee32c45dc801661edf67708f4ae5bec0dc2"
    sha256 cellar: :any, arm64_linux:       "45f5e6e353463c440028ec71fe053d0bc0e4f5613e2771e6978489b2fcb692ba"
    sha256 cellar: :any, x86_64_linux:      "6eaf7420acc4a71bf1d3848d9af481b4d68649d5b22963002947451249c28d0f"
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
