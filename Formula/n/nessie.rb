class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.4.tar.gz"
  sha256 "856cd4478d809316a29b7e008f14b3429f04d54f5920c3d0766a919469c91f76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe8d32366a6698d3cc8f4813c5b79ee5e57d86ea7427695c4c85face26bdaf48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803521fab7cbce3d63bc9aaf4587ef37e40acc6367a04a7cb4433154c79058e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c12605e79174eb836b396f52928bee13ee99f878112d07879401b505a2306991"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15aff12ce1c23b26255f255f5816abbf611c9093150e3bb24c8176680cac6aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f548cb080dbf4e86aef9ad45b373b483ef01f47e2ee7e323a656ab77ea690aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe21d4e1bfebfbdc6c19ad6b54e4cafc75f8490c2784cb52f6bcb1cc030ebf8"
  end

  depends_on "gradle" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie"
  end

  service do
    run [opt_bin/"nessie"]
    keep_alive true
    error_log_path var/"log/nessie.log"
    log_path var/"log/nessie.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end
