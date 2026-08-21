class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.1.tar.gz"
  sha256 "5ffe264d7f85650d4b25217712d1a9e3c602afb681bf3b8b11bb9c6f0a0a3942"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f685ed74285699ea7e5e1a2e8dce2ce8ac66b3a72329a736d74d7d1d612a0174"
    sha256 cellar: :any, arm64_sequoia: "a78015aca17bad5f0fe16814a39044cc4c44e12bef210d3257825096f9a280e3"
    sha256 cellar: :any, arm64_sonoma:  "2ec8a79dab63fb2248beebbbfb968a84600f7030943ce271921370937ea193e6"
    sha256 cellar: :any, sonoma:        "5d1ff9110f6dbeb0d4f927f51f5fafd74c624649031bbfd8dc74af81cc0a8e6e"
    sha256 cellar: :any, arm64_linux:   "f7558e4580b32dc92f8f750fbf450ba970975b95519a4f732919a491b786bb83"
    sha256 cellar: :any, x86_64_linux:  "0c9fbde69af11273a336b15264838a10332120425d9f0818dca5d929a93c9497"
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
