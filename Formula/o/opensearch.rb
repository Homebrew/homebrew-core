class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch/archive/2.11.0.tar.gz"
  sha256 "fa4d7b7300fbb95ae9becbf099c6c33be3ae306a2a067fbee69108212524778e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff3cc4d2be0460aab18e3d05a689f80b257d47e0099e13535eef2dacbf5eaa2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24591ffff5324baab365b9e79d6f55603befe538f2b997ae61535baa4f32440a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab5928d7c478826a613af6c99bb5b4ed36a7c1feaaddececf35c4a1c2f043e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6b0f089dc1a9127d8febda2e41fd7cfe13b7474235b6eb9b5343738ca95e567"
    sha256 cellar: :any_skip_relocation, ventura:        "757f7d7869b3d1f03d75f50654fe5f1151c045f429fd259d2719305b41f08806"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd01125ef2d1d663d4048da0c0be9c9d3d7a356dac4d5518ea05122d3cf1b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6dd98d381364c0e782ffc9fce7992c1939b2986298bd6fbbe71e7e88d30a2ef"
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
