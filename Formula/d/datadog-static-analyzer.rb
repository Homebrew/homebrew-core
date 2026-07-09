class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.8.tar.gz"
  sha256 "f0bba157d262318360c88463613ea165785a3a32e9236c62ee18cc12dae782fc"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b260190c2cfac5d1d157b0193ba645d18230f7baa7c5fe54211b55bb181a1aee"
    sha256 cellar: :any, arm64_sequoia: "1a94e6a547d0497284f9fb0301885be80fc22f1b0798c74b5b72cb3abc951e3b"
    sha256 cellar: :any, arm64_sonoma:  "e19e68b3b495ddb059927fa7f5f0bca649ef5fc2e8d5e31f86e874ccedaaa82b"
    sha256 cellar: :any, sonoma:        "480112267b6843d96eac2037bb6912de4604bb5ad7bfc1a22613c1d4f624bf4f"
    sha256 cellar: :any, arm64_linux:   "ddbbaa2f9299485504be685eef8c3366603f5b8520f61b4f2760e608eec4149d"
    sha256 cellar: :any, x86_64_linux:  "a1a6bbaba6ee54647fb6cdd20fad63fae6ee7a88e24560c3cc59dae26b2b5bff"
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
