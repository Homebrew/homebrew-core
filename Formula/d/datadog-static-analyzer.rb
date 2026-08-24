class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.2.tar.gz"
  sha256 "0cd456053ce12ad49c4bc9580cf1eae0f6db3ac1fc2afe8c92e88ee9e6f7ecc9"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "90899615548c4db1891f270526d0f1dfc6e9be3ec17a5f4858d03e0cd7e7eb50"
    sha256 cellar: :any, arm64_sequoia: "9bcd62a07bdcdda6c76a16a74a81fca7b6041e4c66ea9d4ab139803078f0cb88"
    sha256 cellar: :any, arm64_sonoma:  "fd1e4035ca3b82bfc454af5d327ea2b61a90e962feefb1db46b46224eb844260"
    sha256 cellar: :any, sonoma:        "72538e8666635cb1ce0e65d9ebcb632ff27ebca52cd0564891752c271f5576b0"
    sha256 cellar: :any, arm64_linux:   "b254810b06dc92790b93f1ddc595c00e12b93d42145b49e6fd34c5620364e3f4"
    sha256 cellar: :any, x86_64_linux:  "970a756b17422a6e9f278933234005770b703e6687b8387389d8bd2b7043b198"
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
