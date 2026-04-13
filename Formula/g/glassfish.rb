class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.org/"
  url "https://download.eclipse.org/ee4j/glassfish/glassfish-8.0.1.zip"
  mirror "https://github.com/eclipse-ee4j/glassfish/releases/download/8.0.1/glassfish-8.0.1.zip"
  sha256 "d308659da401ebd59b6b5e43ce760b0cb37622655a765a66bcb9d2ed0c213a75"
  license "EPL-2.0"

  livecheck do
    url "https://download.eclipse.org/ee4j/glassfish/"
    regex(/href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b43ae892b1fa5ccd3ac98276a7c5788e9b1dfdade6cd918af24526811c4b643"
  end

  depends_on "openjdk"

  conflicts_with "payara", because: "both install the same scripts"

  def install
    # Remove all windows files
    rm_r(Dir["bin/*.bat", "glassfish/bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")

    env = Language::Java.overridable_java_home_env
    env["GLASSFISH_HOME"] = libexec
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

    spawn bin/"asadmin", "start-domain", "--domaindir=#{testpath}/domains", "domain1"

    output = shell_output("curl --silent --retry 5 --retry-connrefused -X GET localhost:#{port}")
    assert_match "GlassFish Server", output

    assert_match version.to_s, shell_output("#{bin}/asadmin version")
  end
end
