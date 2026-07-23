class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.9.tar.gz"
  sha256 "3523e64cd160c277bf0edefc2d86e4ea29d2f213ee62dad4a5f26af32ebb5b83"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "642d14a0f81a515b1efa2a43373f8cad33429edd6059b150ce491daea5536c3e"
    sha256 cellar: :any, arm64_sequoia: "2256855baed43b27fe88cb210c34df1f854a5dd67459ea50ddfa73b4c47f9a9f"
    sha256 cellar: :any, arm64_sonoma:  "555f5d4e7ce4e9a3f3d68668dfff11571c737b5365b43585755927d729f39b81"
    sha256 cellar: :any, sonoma:        "39f71f75fe52706135c36c1253ff18c1f0c5ece77f62b593a22785a3c7b824e0"
    sha256 cellar: :any, arm64_linux:   "778fdd61ee9a8784fff6ef658a477112f65aa115e416a67c648a5a8e3d135da0"
    sha256 cellar: :any, x86_64_linux:  "cab9446f713e4239bb7290fa1577e0a7e44ea15ee5efa7331b1137d8a73bf04c"
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
