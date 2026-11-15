class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch.git",
      tag:      "3.9.0",
      revision: "4ee42a94e87f66fbf1e62a9871b1b87f91e02472"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66dc8dfda2d0fc66a9f19a2e60c419a22d3043bc6ad54fdc8654596c86b47320"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "897b3141d42c73adccbadbd3e0670e6369402a8ef913aeeec2ed42ccb7f6aa71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9a3300301e2e0fdac45e27c0ab9de794f560b19b18e775e8867bc62e2099175"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "891b637b6e1ba69e5ee2f03949c85af0ac4cfd8865cb7f0d1a4fbce422da628d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5c63435d50fd0325f5bf3f819b0fe7ac08926f516fc4f5ad990750e41ae3cdab"
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
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk@25"))

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
    pid = spawn bin/"opensearch", "-Ehttp.port=#{port}",
                            "-Epath.data=#{testpath}/data",
                            "-Epath.logs=#{testpath}/logs"
    sleep 30
    output = shell_output("curl -s -XGET localhost:#{port}/")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system bin/"opensearch-plugin", "list"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
