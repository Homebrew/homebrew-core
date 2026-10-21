class PaxRunner < Formula
  desc "Tool to provision OSGi bundles"
  homepage "https://ops4j1.jira.com/wiki/spaces/paxrunner/overview"
  url "https://search.maven.org/remotecontent?filepath=org/ops4j/pax/runner/pax-runner-assembly/1.9.0/pax-runner-assembly-1.9.0-jdk15.tar.gz"
  version "1.9.0"
  sha256 "b1ff2039dc1e73b6957653d967d6ee028f9c79d663b9031a6b77a49932352dc1"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/ops4j/pax/runner/pax-runner-assembly/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f7195e6a142137e103125c0176376e562a2e0ba115d5e61ed15b0c2a00e92cf5"
  end

  depends_on "openjdk" => :test

  deny_network_access!

  def install
    (bin/"pax-runner").write <<~EOS
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir["*"]
  end

  test do
    ENV.prepend_path "PATH", formula_opt_bin("openjdk")

    # Seed a local Maven repository so the Felix framework "download" resolves offline
    felix = testpath/"repo/org/apache/felix/org.apache.felix.main/5.4.0"
    felix.mkpath
    cp libexec/"bin/pax-runner-#{version}.jar", felix/"org.apache.felix.main-5.4.0.jar"

    (testpath/"MANIFEST.MF").write <<~EOS
      Bundle-ManifestVersion: 2
      Bundle-SymbolicName: org.homebrew.test
      Bundle-Version: 1.0.0
    EOS
    system "jar", "cfm", "test.jar", "MANIFEST.MF"

    output = shell_output("#{bin}/pax-runner --executor=noop --noConsole --ee=JavaSE-1.8 " \
                          "--localRepository=#{testpath}/repo file:#{testpath}/test.jar")
    assert_match "Preparing framework [Felix 5.4.0]", output
    assert_match "Skipping platform start and exit immediately", output
    assert_path_exists testpath/"runner/bundles/org.homebrew.test_1.0.0.jar"
    assert_match 'felix.auto.start.5="file:bundles/org.homebrew.test_1.0.0.jar"',
                 (testpath/"runner/felix/config.ini").read
  end
end
