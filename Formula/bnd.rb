class Bnd < Formula
  desc "The Swiss Army Knife for OSGi bundles"
  homepage "https://bnd.bndtools.org/"
  url "https://search.maven.org/remotecontent?filepath=biz/aQute/bnd/biz.aQute.bnd/5.0.1/biz.aQute.bnd-5.0.1.jar"
  sha256 "65ce4dbfae9fba4382037ae8d409bd3e681cc9b315964dca032cf37b18311e1b"

  bottle :unneeded

  def install
    libexec.install "biz.aQute.bnd-#{version}.jar"
    bin.write_jar_script libexec/"biz.aQute.bnd-#{version}.jar", "bnd"
  end

  test do
    # Test bnd by resolving a launch.bndrun file against a trivial index.
    test_sha = "baad835c6fa65afc1695cc92a9e1afe2967e546cae94d59fa9e49b557052b2b1"
    test_bsn = "org.apache.felix.gogo.runtime"
    test_version = "1.0.0"
    test_version_next = "1.0.1"
    test_file_name = "#{test_bsn}-#{test_version}.jar"
    (testpath/"index.xml").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <repository increment="0" name="Untitled" xmlns="http://www.osgi.org/xmlns/repository/v1.0.0">
        <resource>
          <capability namespace="osgi.identity">
            <attribute name="osgi.identity" value="#{test_bsn}"/>
            <attribute name="type" value="osgi.bundle"/>
            <attribute name="version" type="Version" value="#{test_version}"/>
          </capability>
          <capability namespace="osgi.content">
            <attribute name="osgi.content" value="#{test_sha}"/>
            <attribute name="url" value="#{test_file_name}"/>
          </capability>
        </resource>
      </repository>
    EOS

    (testpath/"launch.bndrun").write <<~EOS
      -standalone: ${.}/index.xml
      -runrequires: osgi.identity;filter:='(osgi.identity=#{test_bsn})'
    EOS

    (testpath/"cnf/build.bnd").write <<~EOS
    EOS

    output = shell_output("#{bin}/bnd resolve resolve -b launch.bndrun")
    assert_match /BUNDLES\s+#{test_bsn};version='\[#{test_version},#{test_version_next}\)'/, output
  end
end
