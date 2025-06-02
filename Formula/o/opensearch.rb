class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch/archive/refs/tags/3.0.0.tar.gz"
  sha256 "5701c0a0e801a27cb1fb6521c17138c43a0933e364fa2cfb5a62cfcdcb4e1270"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02c7d73c1f51d079efc702aeabc45e840dfbd6f9c3e3a5d5d39845b7e084f9b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a110cc034a792732c5612adfa6879b8d0cd360d0abb538f4987be274bdf829"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ff98574221a06111ee8663c5a55f9de0661b3275f85c93fea08cc4b93a21abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac2af223ccdc1bc9df151bd53e56415c3ea5a3dd664e9ff6efd32734df83974"
    sha256 cellar: :any_skip_relocation, ventura:       "7316664aaad936f205d760e5e3292b3f567723d05acd4eaf7cf3c7818333a60b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af72cc2f707be2ca3ea709fbf1e597a923e4daa7a3e5610178bb697bb022eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f8b518e5898e1af368400a5053ee50e2df258bc05de53dfcc8549ffffab46f"
  end

  depends_on "gradle" => :build
  # Can be updated after https://github.com/opensearch-project/OpenSearch/pull/18085 is released.
  depends_on "openjdk@21"

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "gradle", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

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
    # Can be updated after https://github.com/opensearch-project/OpenSearch/pull/18085 is released.
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk@21"].opt_prefix)
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
    spawn bin/"opensearch", "-Ehttp.port=#{port}",
                            "-Epath.data=#{testpath}/data",
                            "-Epath.logs=#{testpath}/logs"
    sleep 60
    output = shell_output("curl -s -XGET localhost:#{port}/")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system bin/"opensearch-plugin", "list"
  end
end
