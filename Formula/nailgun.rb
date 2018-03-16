class Nailgun < Formula
  desc "Command-line client, protocol and server for Java programs"
  homepage "http://www.martiansoftware.com/nailgun/"
  url "https://github.com/facebook/nailgun/archive/nailgun-all-0.9.3.tar.gz"
  sha256 "3c1567c8633cdf1a942fbcd13eb07564800866cb4d80680b3fbe8ee07c53e7a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fd2830001fb4033007cba9bdb515076e4d7397c381a3335d2515e055f834075" => :high_sierra
    sha256 "b7e959ca2b996cb7c13409693840d0454fe8a646a64813e9c7d3ac21aa1555df" => :sierra
    sha256 "ccbf9b5b95cbf1b59e1a5698abd13fc9597624e4acafb2f58c840dad444e8cd9" => :el_capitan
  end

  head do
    url "https://github.com/martylamb/nailgun.git"

    # The -Xdoclint used in pom.xml causes a build error on Java 7
    patch do
      url "https://github.com/martylamb/nailgun/pull/70.diff?full_index=1"
      sha256 "802fcb83cd93227dcfa8f988ec5665d980d04087813b776bf25aed15495bdc4f"
    end
  end

  depends_on "maven" => :build

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "CFLAGS=#{ENV.cflags}"
    require "rexml/document"
    pom_xml = REXML::Document.new(File.new("pom.xml"))
    jar_version = REXML::XPath.first(pom_xml, "string(/pom:project/pom:version)", "pom" => "http://maven.apache.org/POM/4.0.0")
    system "mvn", "clean", "install"
    libexec.install Dir["nailgun-server/target/*.jar"]
    bin.write_jar_script libexec/"nailgun-server-#{jar_version}.jar", "ng-server", "-server"
  end

  test do
    fork { exec "#{bin}/ng-server", "8765" }
    sleep 1 # the server does not begin listening as fast as we can start a background process
    system "#{bin}/ng", "--nailgun-port", "8765", "ng-version"
    Kernel.system "#{bin}/ng", "--nailgun-port", "8765", "ng-stop"
    # ng-stop always returns a non-zero exit code even on successful exit
    true
  end
end
