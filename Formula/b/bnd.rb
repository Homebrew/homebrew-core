class Bnd < Formula
  desc "Swiss Army Knife for OSGi bundles"
  homepage "https://bnd.bndtools.org/"
  url "https://search.maven.org/remotecontent?filepath=biz/aQute/bnd/biz.aQute.bnd/7.0.0/biz.aQute.bnd-7.0.0.jar"
  sha256 "674080fc8bb766af9bd721f4847467c6a7a25de3ea6a444525241b34126688b1"
  license any_of: ["Apache-2.0", "EPL-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=biz/aQute/bnd/biz.aQute.bnd/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8549e3e61e7f749cac5e80e09fd3a66a2f8cf38fc370fe3f27866b48694c61a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8549e3e61e7f749cac5e80e09fd3a66a2f8cf38fc370fe3f27866b48694c61a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8549e3e61e7f749cac5e80e09fd3a66a2f8cf38fc370fe3f27866b48694c61a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8549e3e61e7f749cac5e80e09fd3a66a2f8cf38fc370fe3f27866b48694c61a4"
    sha256 cellar: :any_skip_relocation, ventura:        "8549e3e61e7f749cac5e80e09fd3a66a2f8cf38fc370fe3f27866b48694c61a4"
    sha256 cellar: :any_skip_relocation, monterey:       "8549e3e61e7f749cac5e80e09fd3a66a2f8cf38fc370fe3f27866b48694c61a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "874833d2f3ad7da2c19ae2c0218b793e9c34d8067a4de1f3dbd18d6ae43b1d35"
  end

  depends_on "openjdk"

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

    mkdir "cnf"
    touch "cnf/build.bnd"

    output = shell_output("#{bin}/bnd resolve resolve -b launch.bndrun")
    assert_match(/BUNDLES\s+#{test_bsn};version='\[#{test_version},#{test_version_next}\)'/, output)
  end
end
