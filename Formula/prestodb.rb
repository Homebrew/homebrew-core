class Prestodb < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://prestodb.io"
  url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/0.280/presto-server-0.280.tar.gz"
  sha256 "f7d34e748be5d0a274b000d6370f0a3d27570c836f31f7bc46a488162b3d16f6"
  license "Apache-2.0"

  # Upstream has said that we should check Maven for Presto version information
  # and the highest version found there is newest: prestodb/presto/issues/16200
  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "0c2010256dcdf398f3ef943a1738b82e65f7d640683603aa0ba73a1ce30a0ebd"
    sha256 cellar: :any_skip_relocation, monterey:     "0c2010256dcdf398f3ef943a1738b82e65f7d640683603aa0ba73a1ce30a0ebd"
    sha256 cellar: :any_skip_relocation, big_sur:      "0c2010256dcdf398f3ef943a1738b82e65f7d640683603aa0ba73a1ce30a0ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "27e88a69342cebc79f166c78d6f4db18f92c6c4c4a6e29895f0c60ec4e5f793c"
  end

  # https://github.com/prestodb/presto/issues/17146
  depends_on arch: :x86_64
  depends_on "openjdk@11"
  depends_on "python@3.11"

  resource "presto-cli" do
    url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-cli/0.280/presto-cli-0.280-executable.jar"
    sha256 "696d92d8ab2a733e12b62ebc7212fdfabfed60e5911de594eaab5f56d86ce1d5"
  end

  def install
    libexec.install Dir["*"]

    (libexec/"etc/node.properties").write <<~EOS
      node.environment=production
      node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
      node.data-dir=#{var}/presto/data
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
    env = Language::Java.overridable_java_home_env("11")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"presto-server").write_env_script libexec/"bin/launcher", env

    resource("presto-cli").stage do
      libexec.install "presto-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"presto-cli-#{version}-executable.jar", "presto", java_version: "11"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("bin/procname/*")
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" }
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    libprocname_dirs.map(&:rmtree)
  end

  def post_install
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
    sleep 30

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output(bin/"presto --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end
