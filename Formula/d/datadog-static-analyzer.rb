class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.6.tar.gz"
  sha256 "e5b0d9190240d5e2eb72a37438ab5a7c1a0e6107d465dc368b389ee288262926"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "157b8827cf9df85a74dc1ba9a6db15efe47cc407204517bb5e2a55a4044f927f"
    sha256 cellar: :any, arm64_sequoia: "712dcf653ff1cdaec08fe53dc25f0bd4c1c38e6ad9ddaca93060bc526819d137"
    sha256 cellar: :any, arm64_sonoma:  "c53c5f00ae351e2c34dc791943a7438f8e66cd56a1c92f93910a0d14eb9740e0"
    sha256 cellar: :any, sonoma:        "e006203e1c8e1eb16973fc268ab616b5d6ebf09268e5e6b85cc949b06cc9ad30"
    sha256 cellar: :any, arm64_linux:   "3439db7cdd782cc89191a9e55af0ba1f94fa4411a49b246747e8c5d44dec6e90"
    sha256 cellar: :any, x86_64_linux:  "06955383c55744d3e3161e7ed64d6210bb261fb184809222b01bd355a549b961"
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
    assert_match "Static Analysis Summary", output
    assert_path_exists testpath/"output.sarif"
  end
end
