class Prestosql < Formula
  desc "Distributed SQL query engine for big data"
  homepage "https://prestosql.io"
  url "https://search.maven.org/remotecontent?filepath=io/prestosql/presto-server/344/presto-server-344.tar.gz"
  sha256 "9ae950f2901efd5cb1ca7d1bbd8a4cbb01d16dfe9c4fe702db2ee147ab841a8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e7676fdb46e1239f9f1b8087654ea8e897e20d91f054849568098abdc54420c"
  end

  depends_on "openjdk"

  conflicts_with "prestodb", because: "both install `presto` and `presto-server` binaries"

  resource "presto-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/prestosql/presto-cli/344/presto-cli-344-executable.jar"
    sha256 "92de6ce3afa29acea4e9527a1f2e20889008d72ee94cdd34b55c072fd805503e"
  end

  def install
    libexec.install Dir["*"]

    (libexec/"etc/node.properties").write <<~EOS
      node.environment=dev
      node.id=dev
      node.data-dir=#{var}/presto/data
    EOS

    (libexec/"etc/jvm.config").write <<~EOS
      -XX:+UseG1GC
      -XX:G1HeapRegionSize=32M
      -XX:+ExplicitGCInvokesConcurrent
      -XX:+ExitOnOutOfMemoryError
      -Djdk.attach.allowAttachSelf=true
    EOS

    (libexec/"etc/config.properties").write <<~EOS
      coordinator=true
      node-scheduler.include-coordinator=true
      http-server.http.port=8080
      query.max-memory=1GB
      query.max-memory-per-node=1GB
      discovery-server.enabled=true
      discovery.uri=http://localhost:8080
    EOS

    (libexec/"etc/log.properties").write <<~EOS
      io.prestosql=INFO
    EOS

    (libexec/"etc/catalog/jmx.properties").write <<~EOS
      connector.name=jmx
    EOS

    (bin/"presto-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("presto-cli").stage do
      libexec.install "presto-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"presto-cli-#{version}-executable.jar", "presto"
    end
  end

  def post_install
    (var/"presto/data").mkpath
  end

  def caveats
    <<~EOS
      Add connectors to #{opt_libexec}/etc/catalog/. See:
      https://prestosql.io/docs/current/connector.html
    EOS
  end

  service do
    run [opt_bin/"presto-server", "run"]
    working_dir opt_libexec
  end

  test do
    system bin/"presto-server", "run", "--help"
    assert_match "Presto CLI #{version}", shell_output("#{bin}/presto --version").chomp
  end
end
