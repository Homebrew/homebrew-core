class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch.git",
      tag:      "3.10.0",
      revision: "b9f09249b4a9922f0d0bc5bb8f62f90cf95e5eea"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "532340d9c6b5769a4888973ddc9df2bc0ae2a1e824bfa236a07b69f64fa13e89"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c79a104da745504b112aecb443bbe716c40e2f0de068f35d6615726cd422213e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a2bbc64ef8c88b1ec8495504cb0080a44678ae9154c5bc371a9f6c1f8def7d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00c62e5d5738c3ac32beacfde3e98304c9aa652b69e6afbb16e92e237fbf3485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7d061dc3f9c4d9e2e4afc85e7aa3595ad610f9e71f92fde38d550dc68e8f983b"
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
