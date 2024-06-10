class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.org/"
  url "https://download.eclipse.org/ee4j/glassfish/glassfish-7.0.14.zip"
  mirror "https://github.com/eclipse-ee4j/glassfish/releases/download/7.0.14/glassfish-7.0.14.zip"
  sha256 "efcb6e86a9418fe8b33f0b982b52c56e0c7e63d16f91a324a39047a50b8bf2f4"
  license "EPL-2.0"

  livecheck do
    url "https://projects.eclipse.org/projects/ee4j.glassfish/downloads"
    regex(/href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58bb17e797f2e9e6df464a9242c9bb673713dc2ad4129cfa6ba506564b0b9e4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58bb17e797f2e9e6df464a9242c9bb673713dc2ad4129cfa6ba506564b0b9e4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58bb17e797f2e9e6df464a9242c9bb673713dc2ad4129cfa6ba506564b0b9e4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "58bb17e797f2e9e6df464a9242c9bb673713dc2ad4129cfa6ba506564b0b9e4c"
    sha256 cellar: :any_skip_relocation, ventura:        "58bb17e797f2e9e6df464a9242c9bb673713dc2ad4129cfa6ba506564b0b9e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "58bb17e797f2e9e6df464a9242c9bb673713dc2ad4129cfa6ba506564b0b9e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e7f57e2b33a0d631a81afa7414e4a37986716285012919c23a629a1aab73b69"
  end

  # no java 22 support for glassfish 7.x
  # https://github.com/eclipse-ee4j/glassfish/blob/master/docs/website/src/main/resources/download.md
  depends_on "openjdk@21"

  conflicts_with "payara", because: "both install the same scripts"

  def install
    # Remove all windows files
    rm_rf Dir["bin/*.bat", "glassfish/bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]

    env = Language::Java.overridable_java_home_env("21")
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

    fork do
      exec bin/"asadmin", "start-domain", "--domaindir=#{testpath}/domains", "domain1"
    end
    sleep 60

    output = shell_output("curl -s -X GET localhost:#{port}")
    assert_match "GlassFish Server", output

    assert_match version.to_s, shell_output("#{bin}/asadmin version")
  end
end
