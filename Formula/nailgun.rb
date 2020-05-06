class Nailgun < Formula
  desc "Command-line client, protocol and server for Java programs"
  homepage "http://www.martiansoftware.com/nailgun/"
  url "https://github.com/facebook/nailgun/archive/nailgun-all-1.0.1.tar.gz"
  sha256 "c05fc01d28c895d0003b8ec6151c10ee38690552dcfaeb304497836f558006d5"
  head "https://github.com/facebook/nailgun.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e76286672ac4dfa511e5b86c60d6dbd7a16aad954f47eea49d41d371e15a0f9" => :mojave
    sha256 "f72b282a08c6ceb67af42f4f759eb875d283985a614f528a4d7b11a9de722d18" => :high_sierra
    sha256 "b5a6c2a6c5ae333033b822f89a3b2d242d79179a415452f8561317677205fd1e" => :sierra
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "CFLAGS=#{ENV.cflags}"
    require "rexml/document"
    pom_xml = REXML::Document.new(File.new("pom.xml"))
    jar_version = REXML::XPath.first(
      pom_xml,
      "string(/pom:project/pom:version)",
      "pom" => "http://maven.apache.org/POM/4.0.0",
    )
    system "mvn", "clean", "install"
    libexec.install Dir["nailgun-server/target/*.jar"]
    bin.write_jar_script libexec/"nailgun-server-#{jar_version}.jar", "ng-server", "-server"
  end

  test do
    port = free_port.to_s
    fork { exec "#{bin}/ng-server", port }
    sleep 2
    system "#{bin}/ng", "--nailgun-port", port, "ng-version"
    system "#{bin}/ng", "--nailgun-port", port, "ng-stop"
  end
end
