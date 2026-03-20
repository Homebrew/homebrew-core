class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.7.8.tar.gz"
  sha256 "1664164435f8c01708c63c2f3f97421eae73fbe99dca1dec1efc78077fd35e4e"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1f82a86c2cc5ab6608514ee5103164b012c234638fc6ee7f63f5c4bbd9014eb"
    sha256 cellar: :any,                 arm64_sequoia: "0304a18e04ec603d76459238e09afc33600e84b68b5ef5dc3d3704080f845370"
    sha256 cellar: :any,                 arm64_sonoma:  "c7d85c4f05d49f7ccb02a72332e6c9b0bf3abb077e26b4a8721b96d3a266f517"
    sha256 cellar: :any,                 sonoma:        "72a09fd5b6b49630d768ff5efa9fe6e30a51e1cd61ccd8a53be6d17d5fa40842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5fcc7afda9bbab609f0364d643a2026ed7a31f054e89c2e01a58366edb2b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfaf37631b7732cc4518514062db73197e9ac46fe03b273d152c801d39b382c6"
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
    assert_match "Found", output
    assert_path_exists testpath/"output.sarif"
  end
end
