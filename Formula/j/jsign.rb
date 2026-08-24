class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https://ebourg.github.io/jsign/"
  url "https://github.com/ebourg/jsign/archive/refs/tags/7.5.tar.gz"
  sha256 "80667046ce4b6accc205f558bce5c912e918ed9407510474cc6015be3c01b09d"
  license "Apache-2.0"
  head "https://github.com/ebourg/jsign.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d31ce707ac84a804d89f70942aff0dde0616f913a313ed5c1d97c42e3164f402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d31ce707ac84a804d89f70942aff0dde0616f913a313ed5c1d97c42e3164f402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d31ce707ac84a804d89f70942aff0dde0616f913a313ed5c1d97c42e3164f402"
    sha256 cellar: :any_skip_relocation, sonoma:        "d31ce707ac84a804d89f70942aff0dde0616f913a313ed5c1d97c42e3164f402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec35e77a156af2ae9399e7fe32b833b47a0f42145a20dbe657bb870f1234f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec35e77a156af2ae9399e7fe32b833b47a0f42145a20dbe657bb870f1234f70"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21" # The build fails with more recent JDKs

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "mvn", "--batch-mode", "package",
                  "--projects", "jsign-core,jsign-cli,jsign-ant,jsign",
                  "--also-make",
                  "-DskipTests",
                  "-Djdeb.skip",
                  "-Dmaven.javadoc.skip"

    # Fetch the version from the pom (required to build from HEAD)
    require "rexml/document"
    pom = REXML::Document.new(File.new("pom.xml"))
    version = REXML::XPath.first(pom, "string(/pom:project/pom:version)", "pom" => "http://maven.apache.org/POM/4.0.0")

    libexec.install "jsign/target/jsign-#{version}.jar"
    args = %w[
      -Djava.net.useSystemProxies=true
      -Dbasename=jsign
      -Dlog4j2.loggerContextFactory=net.jsign.log4j.simple.SimpleLoggerContextFactory
    ]
    bin.write_jar_script libexec/"jsign-#{version}.jar", "jsign", args.join(" "), java_version: "21"
    bash_completion.install "jsign/src/deb/data/usr/share/bash-completion/completions/jsign"
    man1.install "jsign/src/deb/data/usr/share/man/man1/jsign.1"
  end

  test do
    stable.stage testpath
    res = "jsign-core/src/test/resources"

    system bin/"jsign", "--keystore", "#{res}/keystores/keystore.p12",
                           "--storepass", "password",
                           "#{res}/wineyes.exe"

    system bin/"jsign", "--keystore", "#{res}/keystores/keystore.jks",
                           "--storepass", "password",
                           "#{res}/minimal.msi"

    system bin/"jsign", "--keyfile", "#{res}/keystores/privatekey.pvk",
                           "--certfile", "#{res}/keystores/jsign-test-certificate-full-chain.spc",
                           "--storepass", "password",
                           "#{res}/hello-world.vbs"
  end
end
