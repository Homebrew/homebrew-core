class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.5.tar.gz"
  sha256 "9ada5dd2edd8308fc7bcab556864d1b4ffa332f50ac1bac80a26d2274b9b330c"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e8043e248855c585057180979896f07c6fa25bb2f5b607aef00203f888e6e7f"
    sha256 cellar: :any, arm64_sequoia: "7cc55646bf10c2a70346b719713ff7508d5028be3cba8ee8e6f93eba8031538a"
    sha256 cellar: :any, arm64_sonoma:  "db0a4c4029abe766aa4097d99d0b368c44e34c3e250c9a2589b5bfc8fd6ad9da"
    sha256 cellar: :any, arm64_linux:   "673af74ef880b95eec9ee372c9b6d756c9017546f8a93247f27e605452fff942"
    sha256 cellar: :any, x86_64_linux:  "9e0e047ea18d5de88817628b17e5a2bfe56fbd8e837808073c19894b5f851168"
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
