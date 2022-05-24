class Nailgun < Formula
  desc "Command-line client, protocol and server for Java programs"
  homepage "http://www.martiansoftware.com/nailgun/"
  url "https://github.com/facebook/nailgun/archive/nailgun-all-1.0.1.tar.gz"
  sha256 "c05fc01d28c895d0003b8ec6151c10ee38690552dcfaeb304497836f558006d5"
  license "Apache-2.0"
  head "https://github.com/facebook/nailgun.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "9e4e7836ebcef4beb89f43ba07ff7e1fffb0765b8843cda5338eca8b34bafed3"
    sha256 cellar: :any_skip_relocation, mojave:      "4cbbab0f095c5f5890ae326e7b88b82b4eefa877afe91a63fa161ea82999ee5d"
    sha256 cellar: :any_skip_relocation, high_sierra: "7f5d7051e631b174fd1d7d0c0aea2b957d3b4946e2176828ec687baddaaa4e04"
  end

  deprecate! date: "2020-11-13", because: :does_not_build

  depends_on "maven" => :build
  depends_on "openjdk@8"

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
