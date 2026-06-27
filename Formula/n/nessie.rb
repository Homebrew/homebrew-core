class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.108.1.tar.gz"
  sha256 "70f49b7a8f28bb8e6b209f3eb4f633bab64d28ee52ccb68081ae2cb9203eaf58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe4acdf898ed455bc360c0044d2e60918e0d9d4aea1e2a3fcec66297f861035e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27490f8efa4fa922747128ff7882a76e2284dece88bd75de1d58c89f27b08848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91948c33d13bb2590dd933130fb8b31bc209d6ec78cd72df5c4cab19f84317fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0f12e0e233e98438dda21d9ec9a4c372b3871dce93e384a7772a92627a850f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "456d277dfb705ff1f327792f72d5b51522fd43eb846f607c7326587f544c17b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9e550eae45d7bbf215ae1708cf7076ed2dd94542a79c0699f4941aca198b7c"
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
