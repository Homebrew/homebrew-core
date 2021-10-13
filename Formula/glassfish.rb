class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.org/"
  url "https://download.eclipse.org/ee4j/glassfish/glassfish-6.2.2.zip"
  mirror "https://github.com/eclipse-ee4j/glassfish/releases/download/6.2.2/glassfish-6.2.2.zip"
  sha256 "9cb2a35e639f83d90b78d36d88779bebc258da75485f68f23cfa6823e78b04c0"
  license "EPL-2.0"

  livecheck do
    url "https://projects.eclipse.org/projects/ee4j.glassfish/downloads"
    regex(/href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "738cb660cdf1855f0aa1df4558a594e103467f45a4f7f5b8e4e7b74f9293db5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "738cb660cdf1855f0aa1df4558a594e103467f45a4f7f5b8e4e7b74f9293db5f"
    sha256 cellar: :any_skip_relocation, catalina:      "738cb660cdf1855f0aa1df4558a594e103467f45a4f7f5b8e4e7b74f9293db5f"
    sha256 cellar: :any_skip_relocation, mojave:        "738cb660cdf1855f0aa1df4558a594e103467f45a4f7f5b8e4e7b74f9293db5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "259a91be981f3551b2255578d6d782138168abb8b2dd6d0f19cfa6f66fcc76a5"
  end

  depends_on "openjdk@11"

  conflicts_with "payara", because: "both install the same scripts"

  def install
    # Remove all windows files
    rm_rf Dir["bin/*.bat", "glassfish/bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]

    env = Language::Java.overridable_java_home_env("11")
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
    assert_match version.to_s, shell_output("#{bin}/asadmin version")

    port = free_port
    cp_r libexec/"glassfish/domains", testpath
    inreplace testpath/"domains/domain1/config/domain.xml", "port=\"4848\"", "port=\"#{port}\""

    fork do
      exec bin/"asadmin", "start-domain", "--domaindir=#{testpath}/domains", "domain1"
    end
    sleep 60

    output = shell_output("curl -s -X GET localhost:#{port}")
    assert_match "GlassFish Server", output
  end
end
