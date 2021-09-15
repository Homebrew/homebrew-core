class PaxRunner < Formula
  desc "Tool to provision OSGi bundles"
  homepage "https://ops4j1.jira.com/"
  url "https://search.maven.org/remotecontent?filepath=org/ops4j/pax/runner/pax-runner-assembly/1.8.6/pax-runner-assembly-1.8.6-jdk15.tar.gz"
  version "1.8.6"
  sha256 "42a650efdedcb48dca89f3e4272a9e2e1dcc6bc84570dbb176b5e578ca1ce2d4"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdaa1633b1cc5310e7e6d5edd558316c794d37869976494d6b1b4d465ce1129d"
  end

  def install
    (bin+"pax-runner").write <<~EOS
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir["*"]
  end
end
