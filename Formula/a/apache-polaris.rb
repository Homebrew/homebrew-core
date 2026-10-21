class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.8.0.tar.gz"
  sha256 "c7addba31ff553a49a1b6b6c77b253a519d37da3eee82b90e5321cdc08b76f2d"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f791831e7282a9b53f78a3e590deae0d2e03af1dda645e7c7b537ccd2f9a476"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efa5308e053328888f518435737cc476b6af384f814307a4f2c7d17f247d5d51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cb1d9c2ef4b5849ec6f67a5000eb1de27015825433b24ec4341fc77d573e9bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21255ccd106d2f9c5fd64e085696261267edd4d9986e6f9a27ac01ff4dedf312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7d31554514b827f1948e4c28799fe9300ac94af02a490498808673ff03cf3945"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV.delete "CI" # work around Gradle stalling on macOS CI runners

    # TODO: Remove once the distribution includes the conditional Amazon transport dependency.
    # https://github.com/apache/polaris/issues/5681
    inreplace "runtime/common/build.gradle.kts",
              'implementation("io.quarkiverse.amazonservices:quarkus-amazon-rds")',
              'implementation("io.quarkiverse.amazonservices:quarkus-amazon-rds")' \
              "\n  " \
              'implementation("io.quarkiverse.amazonservices:quarkus-amazon-apache-client-internal")'

    system "gradle", "assemble", "--no-daemon"

    mkdir "build" do
      system "tar", "xzf", "../runtime/distribution/build/distributions/polaris-bin-#{version}.tgz", "--strip-components", "1"
      libexec.install "admin", "bin", "server"
    end

    java_env = Language::Java.overridable_java_home_env
    %w[admin server].each do |script|
      (bin/"polaris-#{script}").write_env_script libexec/"bin"/script, java_env
    end
  end

  service do
    run [opt_bin/"polaris-server"]
    keep_alive true
    error_log_path var/"log/polaris.log"
    log_path var/"log/polaris.log"
  end

  test do
    ENV["QUARKUS_LOG_FILE_PATH"] = (testpath/"polaris.log").to_s
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    pid = spawn bin/"polaris-server"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
