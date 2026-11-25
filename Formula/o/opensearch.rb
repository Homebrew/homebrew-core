class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch.git",
      tag:      "3.10.1",
      revision: "8f41a7a09efd4fc25dfb52f8fa392a1bb930c260"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    manifest_sha256 "ed579ada51cd9db8955fd65846006b1308bc9ad18a568aba974199fdb398d650"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5e966d1dc0af2e08d7e5ffd25cf3786103f23e87fb22aedf4629364d30a2daa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d65215427f7732e51a418f704de7cae35f2a4a62ecbca3b0e3689f81b125363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2aec53381ea372fe440bd82537e894c59d852a1a644f283e9a97712db437a90a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8220f6b16426ec5722a178112288d243139bb09542d9d395b13084ddfd106b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b4af1c7cc1f01ffbb3d268e82b3ad1bad60cbb25249ada97af0ce3027dab63e9"
  end

  # TODO: Use the vendored Gradle wrapper until its minor version matches Homebrew's `gradle`.
  depends_on "openjdk@25"

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "./gradlew", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

    mkdir "tar" do
      # Extract the package to the tar directory
      system "tar", "--strip-components=1", "-xf",
        Dir["../distribution/archives/no-jdk-#{platform}-tar/build/distributions/opensearch-*.tar.gz"].first

      # Install into package directory
      libexec.install "bin", "lib", "modules", "agent"

      # Set up Opensearch for local development:
      inreplace "config/opensearch.yml" do |s|
        # 1. Give the cluster a unique name
        s.gsub!(/#\s*cluster\.name: .*/, "cluster.name: opensearch_homebrew")

        # 2. Configure paths
        s.sub!(%r{#\s*path\.data: /path/to.+$}, "path.data: #{var}/lib/opensearch/")
        s.sub!(%r{#\s*path\.logs: /path/to.+$}, "path.logs: #{var}/log/opensearch/")
      end

      inreplace "config/jvm.options", %r{logs/gc.log}, "#{var}/log/opensearch/gc.log"

      # add placeholder to avoid removal of empty directory
      touch "config/jvm.options.d/.keepme"

      # Move config files into etc
      pkgetc.install Dir["config/*"]
    end

    inreplace libexec/"bin/opensearch-env",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"$OPENSEARCH_HOME\"/config; fi",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"#{etc}/opensearch\"; fi"

    bin.install libexec/"bin/opensearch",
                libexec/"bin/opensearch-keystore",
                libexec/"bin/opensearch-plugin",
                libexec/"bin/opensearch-shard"
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: dep("openjdk").opt_prefix)

    (var/"lib/opensearch").mkpath
    (var/"log/opensearch").mkpath
    (var/"opensearch/plugins").mkpath
    (var/"opensearch/extensions").mkpath
    libexec.install_symlink pkgetc => "config"
    libexec.install_symlink var/"opensearch/plugins"
    libexec.install_symlink var/"opensearch/extensions"
  end

  post_install_steps do
    unless_path_exists "{{etc}}/opensearch/opensearch.keystore" do
      run "opensearch-keystore", args: ["create"], base: :bin
    end
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch/
      Logs:    #{var}/log/opensearch/opensearch_homebrew.log
      Plugins: #{var}/opensearch/plugins/
      Config:  #{etc}/opensearch/
    EOS
  end

  service do
    run opt_bin/"opensearch"
    working_dir var
    log_path var/"log/opensearch.log"
    error_log_path var/"log/opensearch.log"
  end

  test do
    port = free_port
    (testpath/"data").mkdir
    (testpath/"logs").mkdir
    with_test_process(bin/"opensearch", "-Ehttp.port=#{port}",
                      "-Epath.data=#{testpath}/data",
                      "-Epath.logs=#{testpath}/logs") do
      sleep 30
      output = shell_output("curl -s -XGET localhost:#{port}/")
      assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

      system bin/"opensearch-plugin", "list"
    end
  end
end
