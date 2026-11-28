class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.9.0.tar.gz"
  sha256 "272cca5ea964339a48fc9cf2e6d5548107ce2160e26bc048695020fe39706089"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    manifest_sha256 "6e5bfa7ee29ca7ceaf0c3212f69cc7c4a3d211fdb570da592176718058ce1872"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ac5bec114d12a4f0b6e942823f6f166062a99bb0384d4257460682f3f7ce3e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb9e0aa6bb8b2fdc360ad34cdc16e489f7f6c3a03d1905a61d6673a0fd15cf10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31ad1440589b42e3b985dfa1ae18a6da5557f3ed7ff4c29de7539325dbd9f176"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da502dfc18d4619cb9455ded9cdcce58ec703eb7cde3e40b0551a2632aa44704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c971aed910476b6617b947895ed9c735c4f7056729e41cd68c755fc7b9440a78"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  allow_network_access! [:build, :test]

  def install
    ENV.delete "CI" # work around Gradle stalling on macOS CI runners

    # TODO: Remove once the distribution includes the conditional Amazon transport dependency.
    # https://github.com/apache/polaris/issues/5681
    inreplace "runtime/common/build.gradle.kts",
              'implementation("io.quarkiverse.amazonservices:quarkus-amazon-rds")',
              'implementation("io.quarkiverse.amazonservices:quarkus-amazon-rds")' \
              "\n  " \
              'implementation("io.quarkiverse.amazonservices:quarkus-amazon-apache5-client-internal")'

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
    with_test_process(bin/"polaris-server") do
      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
      assert_match "UP", output
    end
  end
end
