class Prestodb < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://prestodb.io"
  url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/0.295/presto-server-0.295.tar.gz"
  sha256 "a585527431a57212baadb201eb1b971b9ab8d2e3323c14d089ba41f60fd0812d"
  license "Apache-2.0"

  # Upstream has said that we should check Maven for Presto version information
  # and the highest version found there is newest:
  # https://github.com/prestodb/presto/issues/16200
  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0391e19cf02ed2b18746fc115dd3fb77ac968156bd7a10de042374197e4b6a40"
  end

  depends_on "openjdk@17"
  depends_on "python@3.14"

  resource "presto-cli" do
    url "https://github.com/prestodb/presto/releases/download/0.295/presto-cli-0.295-executable.jar"
    sha256 "e5b15f37ef402d9b9eb5e71b2e4593241bb24fcb551327359353f06176c69624"

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
    port = free_port
    cp libexec/"etc/config.properties", testpath/"config.properties"
    inreplace testpath/"config.properties", "8080", port.to_s
    server = fork do
      exec bin/"presto-server", "run", "--verbose",
                                       "--data-dir", testpath,
                                       "--config", testpath/"config.properties"
    end
    sleep 60

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output("#{bin}/presto --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end
