class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.110.1.tar.gz"
  sha256 "1c509dec4cbbeca5098e0f170082a1fad4111ffed007a489451f0c11701c2b86"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "8879f1352ec3af9fa8ef5014fa0b8a6d916be9ee75f670011ae9aa9693826d07"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c083ea7016582054c80f8d59b19b553c9f3cbf1f29a99bcb99e8c5bc584c2838"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47ddd67d5c8b96dcf21af6ac35fb7f37c3413f5bc6117cbd1616ac72c134dbc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2a34621c91f4e786a45efd323ab28d42215cc27ffbe6e2d74dee0a706dd2e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "31f53af279fcd100a80a816d41f6547c1b89d8ea8ea925ca2c02c411a21365f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6e22082686804bb726536c4afc24d9dd9922096888fc773aaed4fca262007ee8"
  end

  depends_on "gradle" => :build

  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  # TODO: Remove when Nessie's Quarkus Gradle plugin includes the Gradle 9.8 fix.
  # https://github.com/quarkusio/quarkus/pull/57352
  resource "quarkus-gradle-model" do
    url "https://github.com/quarkusio/quarkus/archive/refs/tags/3.40.1.2.tar.gz"
    sha256 "535a6f316b13ef2a4e9ad6a609341e389a2c53c5d930e80d33504ca3025c4eea"

    # Fix Gradle 9.8 dependency resolution, upstream PR ref, https://github.com/quarkusio/quarkus/pull/57352
    patch do
      url "https://github.com/quarkusio/quarkus/commit/15ec257102a5dc69ef055118006b99a97a7cf16c.patch?full_index=1"
      sha256 "d9dacd8a9b4dc5570c08578dd054e5b1a099cfcb3a1d3071e34df959e28acf45"
      type :unofficial
      resolves "https://github.com/quarkusio/quarkus/pull/57352"
    end
  end

  # Gradle downloads build dependencies; the test starts a local server.
  allow_network_access! [:build, :test]

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    maven_repo = "-Dmaven.repo.local=#{buildpath}/maven-repository"
    quarkus_gradle_model = resource("quarkus-gradle-model")
    quarkus_gradle_model.stage do
      system "gradle", "-p", "devtools/gradle", ":gradle-model:publishToMavenLocal",
                      "-Pversion=#{quarkus_gradle_model.version}", maven_repo, "--no-daemon"
    end
    system "gradle", ":nessie-quarkus:assemble", "-DwithMavenLocal=true", maven_repo, "--no-daemon"
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
    with_test_process(bin/"nessie") do
      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
      assert_match "UP", output
    end
  end
end
