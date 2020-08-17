class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-271.tar.gz"
  sha256 "4aee400641eaeee7f33e1253043b1e644f8a9ec18f95ddc911ff8d35e2ca6530"
  license "MIT"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "775e5443bc4570f5af09ff033609193c69c05d0ab80150cd67811dd1cc3a7e56" => :catalina
    sha256 "8ef8263d13b6dc9d913cf2c13f4c75ecc63c20dab9c7d977d1ecfa0e86977eb1" => :mojave
    sha256 "97546c9316f94cfa738e4bba4363adaa0b3838e3f8bc4aed6b8ae4822b57a182" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on java: "1.8"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.safe_popen_read(cmd).chomp

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
