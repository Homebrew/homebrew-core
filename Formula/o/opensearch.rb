class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch.git",
      tag:      "3.8.0",
      revision: "e5a3c5691be87af6c12dbe3e158c59c04ee72973"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c43adb1d25c94bc339b0f4935ef1087417f7cc7eadcddfc9fdb8b7e3756400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7d56e828e1885ede7e3adb502595a47d66010395a551214781fb236ce0654c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e908826782f1b15322ffa71fc9f900ebf8c3111a714cfa5846249e54e1962709"
    sha256 cellar: :any_skip_relocation, sonoma:        "354105ab2e288f3ab9f9837951d2c8af259609eb815564815749e40351993b0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a74d5b8dc06f7c83b2a01febcdbb1772bbef752efc8f8d7c4141461c031079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f97ef7a2b0aa396252da4fed36b9750ee95bc32855f38168f2b57ab135f9d4a"
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
