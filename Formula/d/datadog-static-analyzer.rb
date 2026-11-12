class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.13.tar.gz"
  sha256 "67e6377e7a8b6958a5501c8e8d29c21319f05e1f671e9ac6c3a85ca63f30278a"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "66d410b21ea24101eaa4bac6a48b0b79b76ebcfada5552a76649103684f72aab"
    sha256 cellar: :any, arm64_tahoe:       "15b898b26fe65516b1f10a9bf9a314e8a2c57652270ba911cfcf63e208af184c"
    sha256 cellar: :any, arm64_sequoia:     "f153578ef428650470a0781b0f5b3680719d283f5a942fa07559d4290eb4b78d"
    sha256 cellar: :any, arm64_linux:       "3cee499019f2eb679f2de9e582879a4563171c4c0e43b6911afc1e48213cdad7"
    sha256 cellar: :any, x86_64_linux:      "7e60697de5a942662ee6bbeabf4a9720c7424d39547340de85b56255e8f4050f"
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
