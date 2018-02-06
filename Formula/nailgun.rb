class Nailgun < Formula
  desc "Command-line client, protocol and server for Java programs"
  homepage "http://www.martiansoftware.com/nailgun/"
  url "https://github.com/facebook/nailgun/archive/nailgun-all-0.9.3.tar.gz"
  sha256 "3c1567c8633cdf1a942fbcd13eb07564800866cb4d80680b3fbe8ee07c53e7a3"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9af3172f4c3250029bd6aaf038e8bd1061f66a3fcc479701c2758f98b9c646ef" => :high_sierra
    sha256 "4d0e4d7cbad1880f6e9d314d448f90f423d6c2c45c268a6cf99b36d103504c58" => :sierra
    sha256 "02cf71ea505409aedd24b227d67b91a24dc1c2db040185424081ecfdb07f3382" => :el_capitan
    sha256 "958b5a30b72b237139cfd7723025f5d9f50f6b6a318fad22c3297f84a48c34eb" => :yosemite
    sha256 "395c49abe28e79d6171f616b2f0cacc317a95aa09123bdee3eae4df4f3249cff" => :mavericks
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
