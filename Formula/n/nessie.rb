class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.8.tar.gz"
  sha256 "321c64af6afd048eee5aadb49fc99b7a0587a24edd18edd242d800e8b6fafff6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2185548bf84dbdeaa02b519798f131f52c9d84ffe9279ddb722f7a1da3a03bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "377a66896703e9cf0c0439deeeca86bc9d0282ddd581839f789ff3c75e474b07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3892a89adc1cd5ec01b3fb741b24034bd91127fbde33842664ce4ac1ee580f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77a50617679d50543662f3d791df9bb4be181748ed1602fc9bdae7e64e624a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d39181ebef1513904d9c53e6492abe376fc3f8c55a3e50184bf0a523bfd891de"
  end

  depends_on "gradle" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie", java_version: "21"
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
