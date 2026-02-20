class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.7.5.tar.gz"
  sha256 "424982e79f60938ec82d3ae51a47c6608dcd4e27fc4e8e19e4cdcca337453c77"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e159cec7cde2ae8534adc13833ebbbd0d12121171dca8bd070cd806491376e31"
    sha256 cellar: :any,                 arm64_sequoia: "4858a2d67ea728c540ef41286fb19c42bd0cdd4ab79e6c69987c6ba96f2dd795"
    sha256 cellar: :any,                 arm64_sonoma:  "9f715fcca8f232575467f2873fe467ac733ad2623176254281bf5a76076f86cc"
    sha256 cellar: :any,                 sonoma:        "b87962ac005b020a707ae2e7d4f86dc13af1d6560e7c7d439bc026f74f6aa266"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f74675529d2c28c6dc22403d9157ebee46601971e31fccf8dad1bf514bd70d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95802573ad14d5e77e4ef27647be1aa23e04dae7b3392f8eda42849789b9f073"
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
