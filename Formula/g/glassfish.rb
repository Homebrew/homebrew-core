class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.org/"
  url "https://download.eclipse.org/ee4j/glassfish/glassfish-8.0.3.zip"
  mirror "https://github.com/eclipse-ee4j/glassfish/releases/download/8.0.3/glassfish-8.0.3.zip"
  sha256 "52e7101c48c17d41883d49e3328ca1fa3d208b408781ac1f798b81caeef7b4ca"
  license "EPL-2.0"

  livecheck do
    url "https://download.eclipse.org/ee4j/glassfish/"
    regex(/href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9452fe8084db896d8f638eec37740d6d9af1bcce463f4d88696820bfdc2df575"
  end

  depends_on "openjdk@25"

  conflicts_with "payara", because: "both install the same scripts"

  def install
    # Remove all windows files
    rm_r(Dir["bin/*.bat", "glassfish/bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")

    env = Language::Java.overridable_java_home_env
    env[:GLASSFISH_HOME] = libexec
    bin.env_script_all_files libexec/"bin", env

    File.open(libexec/"glassfish/config/asenv.conf", "a") do |file|
      file.puts "AS_JAVA=\"#{env[:JAVA_HOME]}\""
    end
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export GLASSFISH_HOME=#{opt_libexec}
    EOS
  end

  test do
    port = free_port
    # `asadmin` needs this to talk to a custom port when running `asadmin version`
    ENV["AS_ADMIN_PORT"] = port.to_s

    cp_r libexec/"glassfish/domains", testpath
    inreplace testpath/"domains/domain1/config/domain.xml", "port=\"4848\"", "port=\"#{port}\""

    pid = spawn bin/"asadmin", "start-domain", "--domaindir=#{testpath}/domains", "domain1"

    output = shell_output("curl --silent --retry 5 --retry-connrefused -X GET localhost:#{port}")
    assert_match "GlassFish Server", output

    assert_match version.to_s, shell_output("#{bin}/asadmin version")
  ensure
    system bin/"asadmin", "stop-domain", "--domaindir=#{testpath}/domains", "domain1"
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
