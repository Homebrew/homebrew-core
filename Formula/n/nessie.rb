class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.110.0.tar.gz"
  sha256 "ce25ee365697e8be771d5c46e6bab2c97a6e933f843e56d289a92cc08fcd6037"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a9e11b3dadd250570466b47d23ed057c6ea850aac1fe8dd48b16e480a478fe5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef20d8f81bbb08f4eb7841e99e5b3197d18882e0c7c45e87130b6f1da35ce9d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a5e7c77f84b252f115b830de449d2e2e0068ea3f375ee85029201bc8acc0ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97bf2881b126f19acc5d07d387b1f73817dbd1e6187a72bbea0ec03128898951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "620063e8aac6c3a11ec9a134827d12c0b8ddf7d2769a66b82fd52c8664fb246e"
  end

  depends_on "gradle" => :build

  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  # TODO: Remove when Nessie's Quarkus Gradle plugin includes the Gradle 9.8 fix.
  # https://github.com/quarkusio/quarkus/pull/57352
  resource "quarkus-gradle-model" do
    url "https://github.com/quarkusio/quarkus/archive/refs/tags/3.40.1.1.tar.gz"
    sha256 "a303ea57ade33812bea0122682bfb709177743676bc2fcca1b65771a1ac5013d"

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
    pid = spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
