class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.org/"
  url "https://download.eclipse.org/ee4j/glassfish/glassfish-8.0.4.zip"
  mirror "https://github.com/eclipse-ee4j/glassfish/releases/download/8.0.4/glassfish-8.0.4.zip"
  sha256 "2412176ccb3e773a95472318cbd519b67c093bc1a75d4f374238b0e54397d364"
  license "EPL-2.0"

  livecheck do
    url "https://download.eclipse.org/ee4j/glassfish/"
    regex(/href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b50d9f9eeb515b1d61c4db98736d1f70fc9d22718278b2a3558d2e034d1ad93e"
  end

  depends_on "openjdk@25"

  conflicts_with "payara", because: "both install the same scripts"

  def install
    # Remove all windows files
    rm_r(Dir["bin/*.bat", "glassfish/bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")

    env = Language::Java.overridable_java_home_env("25")
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
    ENV["AS_HOSTNAME"] = "localhost"

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
