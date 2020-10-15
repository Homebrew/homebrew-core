class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-271.tar.gz"
  sha256 "4aee400641eaeee7f33e1253043b1e644f8a9ec18f95ddc911ff8d35e2ca6530"
  license "MIT"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9bd96229b15d1e21524a704b84c3610fbd05c7bd305606de5fff934806630bd4" => :catalina
    sha256 "aa4d1296a7a044c6590e7a16b78f4ef24fd74547325aa507e1949150225167c1" => :mojave
    sha256 "35ac20c6989da1d373589ce6d32f1ca24499732ca9872c2574a67f7179c0ed02" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on java: "1.8"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true",
                             "-Duser.home=#{buildpath}"

    cd "jmxtrans" do
      # Point JAR_FILE into Cellar where we've installed the jar file
      inreplace "jmxtrans.sh", "$( cd \"$( dirname \"${BASH_SOURCE[0]}\" )/../lib\" "\
                ">/dev/null && pwd )/jmxtrans-all.jar",
                libexec/"target/jmxtrans-#{version}-all.jar"

      # Exec java to avoid forking the server into a new process
      inreplace "jmxtrans.sh", "${JAVA} -server", "exec ${JAVA} -server"

      chmod 0755, "jmxtrans.sh"
      libexec.install %w[jmxtrans.sh target]
      pkgshare.install %w[bin example.json src tools vagrant]
      doc.install Dir["doc/*"]
    end

    (bin/"jmxtrans").write_env_script libexec/"jmxtrans.sh", Language::Java.java_home_env("1.8")
  end

  test do
    jmx_port = free_port
    fork do
      ENV["JMX_PORT"] = jmx_port.to_s
      exec bin/"jmxtrans", pkgshare/"example.json"
    end
    sleep 2

    system "nc", "-z", "localhost", jmx_port
  end
end
