class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.2.tar.gz"
  sha256 "453520f69b628beb90fdc96c0d73e28e8b12efe2e224658c446c998f7093ca23"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09bc5b6540856021e1fe0b5520a9bab9eec8024a8301a68d3093b6c906d91466"
    sha256 cellar: :any,                 arm64_sequoia: "2badcbd600b760322272ff6f4816bdf43767ea6cfe0cac6ff09690b18a729833"
    sha256 cellar: :any,                 arm64_sonoma:  "80a717461beb6f09e6f47dd1bb8f8ef126bf6003c63f5c1059d05bd89de94449"
    sha256 cellar: :any,                 sonoma:        "ba59bd1542757dd7be962900d5d1ca98cd51af99f6cb8556639eeaf8338c4350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8076f2f69bcd71da22b5565c9e04486c97980681c1837e84094a1cac49a71ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e81562f6714d1d05cf1d443e5c55f7180ebc35ca6d15f40f2cd006d332e9fc"
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
