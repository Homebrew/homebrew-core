class Bnd < Formula
  desc "The Swiss Army Knife for OSGi bundles"
  homepage "http://bnd.bndtools.org/"
  url "https://search.maven.org/remotecontent?filepath=biz/aQute/bnd/biz.aQute.bnd/3.3.0/biz.aQute.bnd-3.3.0.jar"
  sha256 "b6b68dfcd0f5ba767a202bf35eb3eb964c63e679e8217dd514dac807e6cedee8"

  bottle :unneeded

  def install
    libexec.install "biz.aQute.bnd-#{version}.jar"
    bin.write_jar_script libexec/"biz.aQute.bnd-#{version}.jar", "bnd"
  end

  test do
    # Test bnd by resolving a launch.bndrun file against a trivial index.
    test_sha = "baad835c6fa65afc1695cc92a9e1afe2967e546cae94d59fa9e49b557052b2b1"
    test_bsn = "org.apache.felix.gogo.runtime"
    test_file_name = "#{test_bsn}-1.0.0.jar"
    (testpath/"index.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="utf-8"?>
      <repository increment="0" name="Untitled" xmlns="http://www.osgi.org/xmlns/repository/v1.0.0">
        <resource>
          <capability namespace="osgi.identity">
            <attribute name="osgi.identity" value="#{test_bsn}"/>
          </capability>
          <capability namespace="osgi.content">
            <attribute name="osgi.content" value="#{test_sha}"/>
            <attribute name="url" value="#{test_file_name}"/>
          </capability>
        </resource>
      </repository>
    EOS

    (testpath/"launch.bndrun").write <<-EOS.undent
      -standalone: index.xml
      -runrequires: osgi.identity;filter:='(osgi.identity=#{test_bsn})'
    EOS

    output = shell_output("#{bin}/bnd resolve resolve -b launch.bndrun")
    assert_match /launch.bndrun\s+ok/, output
    assert_match /#{test_bsn}\s+#{test_sha}.*#{test_file_name}/, output
  end
end
