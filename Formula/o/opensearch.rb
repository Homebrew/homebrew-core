class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch.git",
      tag:      "3.6.0",
      revision: "4ca747d8d47f80162db323019357447126732e35"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d4c2365ca4db4bdeeeacc439b2862fdc2ec1669debb0112ecd68fd3e1f2d375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6485d06559c900bb2e84410fc897998a803c7c62757f152b504bddd1e40e5c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6622bed240cc4c5cabd443bfbf1a1db97db8abef445310d4842d25237dfba320"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ce4783200e4fc7a550732e3e9bfed8d74d273a5209fef18e2473e7edde439ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4766c1cd628f563b7a97b162ad7673990f55e20bc45284d0d12d848937e46d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8f399ee6a63960c551fa3415c060a72d35f5c816656eff6ae27442c99402508"
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
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk@25"].opt_prefix)
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
