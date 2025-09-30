class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/refs/tags/jmxtrans-parent-272.tar.gz"
  sha256 "73691dc634be8ff504ed33867807266545d9ff9402e365c09fcf0272720cc160"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "f55c75730632187661589592bc60ce5846195fa7b90bea0d6f680bb0d1e3b37f"
    sha256 cellar: :any_skip_relocation, ventura:      "bfb7084ad1740683f32109d720b9b0e19b0c33ce75c67cb41b4e943f9a2c6454"
    sha256 cellar: :any_skip_relocation, monterey:     "2014fcd1c2a53a9f3a396c039f3ad1b530548dabf8e55f8648819b8581c1e0a2"
    sha256 cellar: :any_skip_relocation, big_sur:      "f83bb65c93c0149c4af9b3277d2ec1eee6fd0e94f2a27af0de47c18d3932e9fb"
    sha256 cellar: :any_skip_relocation, catalina:     "f8e5ac84ca621fbb2c0b0c9715899c8e7b2e86f198330b49c7ba7e3d993ec24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "33004f7a6ece9cc9b0c6a0fa1640bf3176237a860012a2df0b2c71ce0a722396"
  end

  # no new commits since March 31 2021, lots of bug reports in https://github.com/jmxtrans/jmxtrans/issues
  deprecate! date: "2024-07-26", because: :unmaintained
  disable! date: "2025-07-26", because: :unmaintained

  depends_on "maven" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  uses_from_macos "netcat" => :test

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@8"].opt_prefix

    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true",
                             "-Duser.home=#{buildpath}"

    cd "jmxtrans" do
      # Point JAR_FILE into Cellar where we've installed the jar file
      inreplace "jmxtrans.sh", "$( cd \"$( dirname \"${BASH_SOURCE[0]}\" )/../lib\" " \
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

    # Delete 32-bit Linux binaries
    rm Dir[libexec/"target/generated-resources/appassembler/jsw/jmxtrans/{bin,lib}/*wrapper-linux-x86-32*"]
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
