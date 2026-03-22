class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.7.9.tar.gz"
  sha256 "8847ae9f4e20378d015755f1a6408f5da42f18c244dca3e149083db15800e190"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cada71c9a09d11e16f6cf2173adcaf9a6688043d1362ab5af97ccf95959a6709"
    sha256 cellar: :any,                 arm64_sequoia: "cbe6978c266a448216204761d6d2eba453ebc6451c8f7e5bf72f60aa6f8f582e"
    sha256 cellar: :any,                 arm64_sonoma:  "67a870265dc236ad45b444105dd87f0ffef6a53958acf4ab727af4ea91a1c188"
    sha256 cellar: :any,                 sonoma:        "bb595af72d4266a4ee526e4fcd82e9076807243438dbaef7c95ce007d9da8951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f450c7ded456dde2fb662dd781d5f58a903a2829249664633acf5cbb12fda0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df76e303b8332d0b6efee7df7a1b430607f357fb908867aeb40bd8c674d84e23"
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
