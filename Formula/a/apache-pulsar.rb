class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.2.4/apache-pulsar-4.2.4-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.2.4/apache-pulsar-4.2.4-src.tar.gz"
  sha256 "c3e2f12ac2160b11a23602583a900eefd959f01b8fb675f400f7642b895917c8"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fe67e7be69710722be40ff5f496ebb6c041f33e989addc3f8eaa58c9bfe313c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05d0b7c1541bd2f8f3ce23d3ab6ae577b7ba6aa46923a6b9e95e8feb9bc5febb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de1f8977e3928c3688469e753b9f43bc8db7d1c0b237e9000be55bba203f487d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d0e404514cc6c573a37eddad0b3a6dac26b9086a7fdf6ce0c0e44dbb1a14ff1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb6da872a01ac40766eed9befb355eac9909c910f2ddc95e5d4e78145536bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31af4a5234a6692a5f6eedfc5d5d5d4efd922294a16768de22a101009a8b170c"
  end

  depends_on "maven" => :build
  depends_on "protoc-gen-grpc-java" => :build
  depends_on "openjdk@21"

  def install
    # Pin gRPC Java version to that of protoc-gen-grpc-java
    inreplace "pom.xml",
              %r{<grpc.version>\d+(?:\.\d+)+</grpc.version>},
              "<grpc.version>#{Formula["protoc-gen-grpc-java"].version}</grpc.version>"

    # Avoid using pre-built `protoc-gen-grpc-java`
    grpc_java_files = ["pulsar-client/pom.xml", "pulsar-functions/proto/pom.xml"]
    plugin_artifact = "io.grpc:protoc-gen-grpc-java:${protoc-gen-grpc-java.version}:exe:${os.detected.classifier}"
    inreplace grpc_java_files, %r{<pluginArtifact>#{Regexp.escape(plugin_artifact)}\s*</pluginArtifact>}, ""

    java_home_env = Language::Java.java_home_env("21")
    with_env(TMPDIR: buildpath, **java_home_env) do
      # Exclude the `docker` module, we don't need the image.
      system "mvn", "clean", "package", "-DskipTests", "-Pcore-modules",
                    "-pl", "!:docker-images,!:pulsar-docker-image,!:pulsar-all-docker-image"
    end

    tarball = if build.head?
      Dir["distribution/server/target/apache-pulsar-*-bin.tar.gz"].first
    else
      "distribution/server/target/apache-pulsar-#{version}-bin.tar.gz"
    end

    libexec.mkpath
    system "tar", "--extract", "--file", tarball, "--directory", libexec, "--strip-components=1"
    pkgshare.install libexec/"examples"
    (etc/"pulsar").install_symlink libexec/"conf"

    rm libexec.glob("bin/*.cmd")
    libexec.glob("bin/*") do |path|
      next if !path.file? || path.fnmatch?("*common.sh")

      (bin/path.basename).write_env_script path, java_home_env
    end

    (var/"log/pulsar").mkpath
  end

  service do
    run [opt_bin/"pulsar", "standalone"]
    log_path var/"log/pulsar/output.log"
    error_log_path var/"log/pulsar/error.log"
  end

  test do
    ENV["PULSAR_GC_LOG"] = "-Xlog:gc*:#{testpath}/pulsar_gc_%p.log:time,uptime:filecount=10,filesize=20M"
    ENV["PULSAR_LOG_DIR"] = testpath
    ENV["PULSAR_STANDALONE_USE_ZOOKEEPER"] = "1"

    pid = spawn bin/"pulsar", "standalone", "--zookeeper-dir", testpath/"zk", "--bookkeeper-dir", testpath/"bk"
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
