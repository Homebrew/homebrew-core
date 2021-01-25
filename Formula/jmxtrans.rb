class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-271.tar.gz"
  sha256 "4aee400641eaeee7f33e1253043b1e644f8a9ec18f95ddc911ff8d35e2ca6530"
  license "MIT"
  revision 1
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "96faa92ad0e8117a5376a7fc24432027429caafe40c1d918cdb738089d1d9f28" => :big_sur
    sha256 "5fee07fef9c31f52a0b00441e1a8e0bf2cb2d5c64e7d2349c7482c220516c816" => :catalina
    sha256 "4c5edee577aca39e0559011f715169a1cc9e29f94439acfd9625242a6fef114c" => :mojave
    sha256 "7968cefc0a3b6b81afc15121cef7025c32e540636b36e70691a0e752ed6abdf8" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk@8"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@8"].opt_prefix

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

    (bin/"jmxtrans").write_env_script libexec/"jmxtrans.sh", JAVA_HOME: Formula["openjdk@8"].opt_prefix
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
