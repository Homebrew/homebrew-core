class Prestodb < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://prestodb.io"
  url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/0.284/presto-server-0.284.tar.gz"
  sha256 "2f5fa06f209ee62f8b4ce3be65e56d50cee44e364ed52866ba5832759008d18d"
  license "Apache-2.0"

  # Upstream has said that we should check Maven for Presto version information
  # and the highest version found there is newest:
  # https://github.com/prestodb/presto/issues/16200
  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "da6bad09a34776d0e74edd0af0dc35691cf44e81f57dfaff775e485d6838f1d1"
    sha256 cellar: :any_skip_relocation, ventura:      "da6bad09a34776d0e74edd0af0dc35691cf44e81f57dfaff775e485d6838f1d1"
    sha256 cellar: :any_skip_relocation, monterey:     "da6bad09a34776d0e74edd0af0dc35691cf44e81f57dfaff775e485d6838f1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e0fef48bd8d046cd9e3e3aebe3dad3485236d920553a2e41be77ff02f3dbf2e"
  end

  # https://github.com/prestodb/presto/issues/17146
  depends_on arch: :x86_64
  depends_on "openjdk@11"
  depends_on "python@3.11"

  resource "presto-cli" do
    url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-cli/0.284/presto-cli-0.284-executable.jar"
    sha256 "628f71ee15c4ddbec7d6394fc069980f158af7c2d6eefc58758ea86dd46daff8"
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
