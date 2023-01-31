class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.org/"
  url "https://download.eclipse.org/ee4j/glassfish/glassfish-7.0.1.zip"
  mirror "https://github.com/eclipse-ee4j/glassfish/releases/download/7.0.1/glassfish-7.0.1.zip"
  sha256 "24d2f12dbff42782af1adb6e2c2898c19c901669ef3e4428b0cb9bf74595e6ac"
  license "EPL-2.0"

  livecheck do
    url "https://projects.eclipse.org/projects/ee4j.glassfish/downloads"
    regex(/href=.*?glassfish[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f56c18877af7bd6d49496282807e73e9efe1dcf795af88d3bfb1d3c3d18fc14"
  end

  depends_on "openjdk@17"

  conflicts_with "payara", because: "both install the same scripts"

  # upstream PR ref, https://github.com/eclipse-ee4j/glassfish/pull/24283
  patch :DATA

  def install
    # Remove all windows files
    rm_rf Dir["bin/*.bat", "glassfish/bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]

    env = Language::Java.overridable_java_home_env("17")
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

__END__
diff --git a/glassfish/config/branding/glassfish-version.properties b/glassfish/config/branding/glassfish-version.properties
index e92142e..2147005 100644
--- a/glassfish/config/branding/glassfish-version.properties
+++ b/glassfish/config/branding/glassfish-version.properties
@@ -19,7 +19,7 @@ product_name=Eclipse GlassFish
 abbrev_product_name=GlassFish
 major_version=7
 minor_version=0
-update_version=0
+update_version=1
 build_id=master-b160-g0b1e109 2020-12-19T17:24:00+0000
 version_prefix=
 version_suffix=
