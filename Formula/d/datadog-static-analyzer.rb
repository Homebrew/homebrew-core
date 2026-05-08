class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.4.tar.gz"
  sha256 "b442a0db20dd09d40746fade2fbcb92cf1d4e7a5e775bc6e3a94c1c5864dce60"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6559e9f88409e521604df014691d6d59ece1be267a1e81aa6d14a3839c3f10f5"
    sha256 cellar: :any,                 arm64_sequoia: "05efbff383dce0fe3361e647184b11288e37c487b0c50bb796b65bdb4e2c1266"
    sha256 cellar: :any,                 arm64_sonoma:  "1cd70a5f73230ddf02fa1d4922ca66def2984cdb89fc9c2c1976f13ca3477e57"
    sha256 cellar: :any,                 sonoma:        "eb3412dfe212288ff7f897378a38048e891704a8fc4493f1ff28d26a60ffa840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70fe5e1682122c079f1c0d6348791ceed19e49452de24203cf66183dcd59a58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90af02968ae27233c2ab53770cd7a36b00b7b8d2f558b0e16c5b2f7ac1ec7bce"
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
