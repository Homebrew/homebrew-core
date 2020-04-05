class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://github.com/eclipse-ee4j/glassfish"
  url "https://www.eclipse.org/downloads/download.php?file=/glassfish/glassfish-5.1.0.zip&r=1"
  sha256 "26f3fa6463d24c5ed3956e4cab24a97e834ca37d7a23d341aadaa78d9e0093ce"

  bottle :unneeded

  depends_on :java => "1.8"

  conflicts_with "payara", :because => "both install the same scripts"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*", ".org.opensolaris,pkg"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export GLASSFISH_HOME=#{opt_libexec}
    EOS
  end

  test do
    # check version
    system "#{opt_libexec}/glassfish/bin/asadmin version | grep #{version}"

    mkdir testpath/"glassfish"
    cp_r libexec/"glassfish", testpath/"glassfish"

    asadmin = testpath/"glassfish/glassfish/bin/asadmin"
    asenv_conf_path = testpath/"glassfish/glassfish/config/asenv.conf"
    domains_path = testpath/"glassfish/glassfish/domains"
    domain_xml_path = domains_path/"domain1/config/domain.xml"
    domaindir_arg = "--domaindir=#{domains_path}"

    # tell glassfish to use Java 8
    java8_home = Utils.popen_read(Language::Java.java_home_cmd("1.8")).chomp
    File.open(asenv_conf_path, "a") { |file| file.puts "AS_JAVA=\"#{java8_home}\"" }

    port = free_port

    # assign port to glassfish admin console
    text = File.read(domain_xml_path)
    new_contents = text.gsub(/port\=\"4848\"/, "port=\"#{port}\"")
    File.open(domain_xml_path, "w") { |file| file.puts new_contents }

    fork do
      exec asadmin, "start-domain", domaindir_arg, "domain1"
    end

    sleep 15

    begin
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "GlassFish Server", output
    ensure
      exec asadmin, "stop-domain", domaindir_arg, "domain1"
    end
  end
end
