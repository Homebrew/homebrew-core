class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch.git",
      tag:      "3.7.0",
      revision: "72121f014083f9ca010fd5a7da83b2ec4886027f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "418e7068af25b035d8c73cde5ec31c562e2d94d726ff1bd2eda7011f0cb2916c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d155153c11c823656d1bc6d5691be5b9615a9564312513c06605ae53420ac91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6389deceddb31f08816e4de2f82e518c1bd56af87c30b5be3d552133d1944f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "b02d817c8de1d16abc9196971c33327a068975d6dd60f74ce5e0a802b91ad91f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084a293e4e80e8e45f2f81bd699e05a1d2a7c03223d9936d0851899514e96d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77efff352a3ad0637f535711d3e9aac2d7c957aaea9e245fd3c7e5903d9f3275"
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
      (etc/"opensearch").install Dir["config/*"]
    end

    inreplace libexec/"bin/opensearch-env",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"$OPENSEARCH_HOME\"/config; fi",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"#{etc}/opensearch\"; fi"

    bin.install libexec/"bin/opensearch",
                libexec/"bin/opensearch-keystore",
                libexec/"bin/opensearch-plugin",
                libexec/"bin/opensearch-shard"
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk@25"))
  end

  def post_install
    # Make sure runtime directories exist
    (var/"lib/opensearch").mkpath
    (var/"log/opensearch").mkpath
    ln_s etc/"opensearch", libexec/"config" unless (libexec/"config").exist?
    (var/"opensearch/plugins").mkpath
    ln_s var/"opensearch/plugins", libexec/"plugins" unless (libexec/"plugins").exist?
    (var/"opensearch/extensions").mkpath
    ln_s var/"opensearch/extensions", libexec/"extensions" unless (libexec/"extensions").exist?
    # fix test not being able to create keystore because of sandbox permissions
    system bin/"opensearch-keystore", "create" unless (etc/"opensearch/opensearch.keystore").exist?
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
