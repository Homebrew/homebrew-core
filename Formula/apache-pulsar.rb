class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.8.0/apache-pulsar-2.8.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.8.0/apache-pulsar-2.8.0-src.tar.gz"
  sha256 "0e161a81c62c7234c1e0c243bb6fe30046ec1cd01472618573ecdc2a73b1163b"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "openjdk@11"

  def install
    chmod "+x", "src/rename-netty-native-libs.sh"
    with_env(
      "PATH"      => "#{Formula["openjdk@11"].bin}:#{ENV["PATH"]}",
      "JAVA_HOME" => Formula["openjdk@11"].opt_prefix,
      "TMPDIR"    => buildpath,
    ) do
      system "mvn", "-X", "clean", "package", "-DskipTests", "-DprotocCommand=protoc", "-Pcore-modules"
    end
    system "tar", "-xf", "distribution/server/target/apache-pulsar-#{version}-bin.tar.gz"
    binpfx = "apache-pulsar-#{version}"
    libexec.install binpfx+"/bin", binpfx+"/lib", binpfx+"/instances", binpfx+"/conf"
    (libexec/"lib/presto/bin/procname/Linux-ppc64le").rmtree
    share.install binpfx+"/examples"
    share.install binpfx+"/licenses"
    (var/"log/pulsar").mkpath
    (etc/"pulsar").mkpath
    (etc/"pulsar").install_symlink libexec/"conf"

    Pathname.glob("#{libexec}/bin/*") do |path|
      if !path.fnmatch?("*common.sh") && !path.directory?
        bin_name = path.basename
        (bin+bin_name).write <<~EOS
          #!/bin/bash
          export PATH="#{Formula["openjdk@11"].bin}:$PATH"
          export JAVA_HOME="#{Formula["openjdk@11"].opt_prefix}"
          exec "#{libexec}/bin/#{bin_name}" "$@"
        EOS
      end
    end
  end

  service do
    run [bin/"pulsar", "standalone"]
    log_path var/"log/pulsar/output.log"
    error_log_path var/"log/pulsar/error.log"
  end

  test do
    fork do
      exec bin/"pulsar", "standalone", "--zookeeper-dir", "#{testpath}/zk", " --bookkeeper-dir", "#{testpath}/bk"
    end
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 15

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end
