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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f7195e6a142137e103125c0176376e562a2e0ba115d5e61ed15b0c2a00e92cf5"
  end

  def install
    (bin/"pax-runner").write <<~EOS
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir["*"]
  end
end
