class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.109.0.tar.gz"
  sha256 "d674f6665c344d47c14c5ee33df29f2e814ef8d67acdfcd1ad2c176e17fefc84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25822d48b068ccad97580165abd163fc5f4fb67f4855a3bc366a01ac795566bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "461c827d3d142a080aa7e834b451990447daac6f8206d91a6bd75ceac45daaed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cad5187d960aae520784dffe442aeccfd422d43ae43ff22957031ca143b5e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a7fd95420510023085f186ee47042014293e19271f6ba15754d790aca451a976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "31240555d8b183edf9f3069888d9b73878f63bc3bfa433d799efb9633b6d050a"
  end

  depends_on "gradle" => :build

  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  # TODO: Remove when Nessie's Quarkus Gradle plugin includes the Gradle 9.8 fix.
  # https://github.com/quarkusio/quarkus/pull/57352
  resource "quarkus-gradle-model" do
    url "https://github.com/quarkusio/quarkus/archive/refs/tags/3.40.1.tar.gz"
    sha256 "6f7ce8c9eda0bb470c69f407da89e7d02f745bfba3c8b13e7ad52750f9a46ce6"

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
    resource("quarkus-gradle-model").stage do
      system "gradle", "-p", "devtools/gradle", ":gradle-model:publishToMavenLocal",
                      "-Pversion=3.40.1", maven_repo, "--no-daemon"
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
    pid = spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
