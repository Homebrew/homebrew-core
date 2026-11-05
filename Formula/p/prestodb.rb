class Prestodb < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://prestodb.io"
  # Maven Central rate-limits this runtime artifact (HTTP 429), so use Google's mirror of it
  url "https://maven-central.storage-download.googleapis.com/maven2/com/facebook/presto/presto-server/0.300/presto-server-0.300.tar.gz"
  mirror "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/0.300/presto-server-0.300.tar.gz"
  sha256 "4235fe5e1484213132b19b4c26cfda1c6beab0d5b5358a11ee014e3fcbb2f5ac"
  license "Apache-2.0"

  # Upstream has said that we should check Maven for Presto version information
  # and the highest version found there is newest:
  # https://github.com/prestodb/presto/issues/16200
  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81257ae1aedb37811384c1d42cbfe1d2e6b78946e7b91222a5452bbd35b39c7c"
  end

  depends_on "openjdk@17"
  depends_on "python@3.15"

  resource "presto-cli" do
    url "https://github.com/prestodb/presto/releases/download/0.300/presto-cli-0.300-executable.jar"
    sha256 "388127e1c7c6758949282b6168c4212a2120f5e159e1aa86a8947e69d534266b"

    livecheck do
      formula :parent
    end
  end

  def install
    java_version = "17"
    odie "presto-cli resource needs to be updated" if version != resource("presto-cli").version

    libexec.install Dir["*"]

    (libexec/"etc/node.properties").write <<~EOS
      node.environment=production
      node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
      node.data-dir=#{var}/prestodb/data
    EOS

    (libexec/"etc/jvm.config").write <<~EOS
      -server
      -Xmx16G
      -XX:+UseG1GC
      -XX:G1HeapRegionSize=32M
      -XX:+UseGCOverheadLimit
      -XX:+ExplicitGCInvokesConcurrent
      -XX:+HeapDumpOnOutOfMemoryError
      -XX:+ExitOnOutOfMemoryError
      -Djdk.attach.allowAttachSelf=true
    EOS

    (libexec/"etc/config.properties").write <<~EOS
      coordinator=true
      node-scheduler.include-coordinator=true
      http-server.http.port=8080
      query.max-memory=5GB
      query.max-memory-per-node=1GB
      discovery-server.enabled=true
      discovery.uri=http://localhost:8080
    EOS

    (libexec/"etc/log.properties").write "com.facebook.presto=INFO"

    (libexec/"etc/catalog/jmx.properties").write "connector.name=jmx"

    rewrite_shebang detected_python_shebang, libexec/"bin/launcher.py"
    env = Language::Java.overridable_java_home_env(java_version)
    (bin/"presto-server").write_env_script libexec/"bin/launcher", env

    resource("presto-cli").stage do
      libexec.install "presto-cli-#{version}-executable.jar"
      bin.write_jar_script(libexec/"presto-cli-#{version}-executable.jar", "presto", java_version:)
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = (libexec/"bin/procname").children
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" }
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    rm_r libprocname_dirs

    (var/"presto/data").mkpath
  end

  def caveats
    <<~EOS
      Add connectors to #{opt_libexec}/etc/catalog/. See:
      https://prestodb.io/docs/current/connector.html
    EOS
  end

  service do
    run [opt_bin/"presto-server", "run"]
    working_dir opt_libexec
  end

  test do
    config = testpath/"config.properties"
    query = "SELECT state FROM system.runtime.nodes"
    port = free_port

    cp libexec/"etc/config.properties", config
    inreplace config, "8080", port.to_s
    output_log = testpath/"output.log"
    server = spawn(bin/"presto-server", "--verbose", "--data-dir", testpath, "--config", config, "run",
                   [:out, :err] => output_log.to_s)
    sleep 60
    if OS.mac?
      # Server doesn't properly start up in macOS sandbox so just check if initial startup logs show up
      assert_match "com.facebook.presto.server.PrestoServer", output_log.read
    else
      assert_match '"active"', shell_output("#{bin}/presto --debug --server localhost:#{port} --execute '#{query}'")
    end
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end
