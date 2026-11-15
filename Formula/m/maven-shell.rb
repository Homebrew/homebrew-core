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

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5a843fccb7f0f9c53ab493d82fe2d2579cdce60d16f3274437bb7a01c9475b72"
  end

  depends_on "openjdk" => :test

  deny_network_access!

  def install
    # Remove windows files.
    rm(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/mvnsh"
  end

  test do
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    # Old Guice/XStream need reflective access on modern Java
    opens = %w[java.base/java.util java.base/java.lang.reflect java.base/java.text java.desktop/java.awt.font]
    ENV["MAVEN_OPTS"] = "-Duser.home=#{testpath} " + opens.map { |o| "--add-opens=#{o}=ALL-UNNAMED" }.join(" ")

    assert_equal "hello world", shell_output("#{bin}/mvnsh -c 'echo hello world'").strip
  end
end
