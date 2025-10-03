class MavenShell < Formula
  desc "Shell for Maven"
  homepage "https://github.com/jdillon/mvnsh"
  url "https://search.maven.org/remotecontent?filepath=org/sonatype/maven/shell/dist/mvnsh-assembly/1.1.0/mvnsh-assembly-1.1.0-bin.tar.gz"
  sha256 "584008d726bf6f90271f4ccd03b549773cbbe62ba7e92bf131e67df3ac5a41ac"
  license "EPL-1.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/sonatype/maven/shell/dist/mvnsh-assembly/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8cf238b82fe150f113e5df470ec8f73d9d8cb58d940c716726a3442492a8fa16"
  end

  def install
    # Remove windows files.
    rm(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/mvnsh"
  end
end
