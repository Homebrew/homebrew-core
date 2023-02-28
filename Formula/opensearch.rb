class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch/archive/2.6.0.tar.gz"
  sha256 "977c26b153146bee8295d439ee064fc5d4b9af4687e6b986da948cea8681fe7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba6f3f7d97418a752af479cc249f251a02b8d363383aa5adc74e3e2ffaabe1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d6d15a6bb96ad3291e6520d4cd45596afcef150b4fc82e6abeb73171043434"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "871091f1c83d7b858f77a738637cea82f5a419d6f6609ceff77af5b315e48cb8"
    sha256 cellar: :any_skip_relocation, ventura:        "21a3a27d19d7fc711b0f05a2e9427f9983572413743e7eb8539462405f2ccba1"
    sha256 cellar: :any_skip_relocation, monterey:       "70f4b0d6d0eec31da9072477561facfc88ae58a2ac0d3732b0018815b1772c32"
    sha256 cellar: :any_skip_relocation, big_sur:        "227e7d35da3b6afac733ec6726709b9473f536205cc847864d9e92f4e5dd9f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "392310a02bcf75c3349aeba9bf9a365185e9eefbb865bc76f45cc331eaf94be1"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "gradle", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

    mkdir "tar" do
      # Extract the package to the tar directory
      system "tar", "--strip-components=1", "-xf",
        Dir["../distribution/archives/no-jdk-#{platform}-tar/build/distributions/opensearch-*.tar.gz"].first

      # Install into package directory
      libexec.install "bin", "lib", "modules"

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
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  def post_install
    # Make sure runtime directories exist
    (var/"lib/opensearch").mkpath
    (var/"log/opensearch").mkpath
    ln_s etc/"opensearch", libexec/"config" unless (libexec/"config").exist?
    (var/"opensearch/plugins").mkpath
    ln_s var/"opensearch/plugins", libexec/"plugins" unless (libexec/"plugins").exist?
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
    fork do
      exec bin/"opensearch", "-Ehttp.port=#{port}",
                             "-Epath.data=#{testpath}/data",
                             "-Epath.logs=#{testpath}/logs"
    end
    sleep 60
    output = shell_output("curl -s -XGET localhost:#{port}/")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system "#{bin}/opensearch-plugin", "list"
  end
end
