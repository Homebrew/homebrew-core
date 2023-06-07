class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https://ebourg.github.io/jsign/"
  url "https://github.com/ebourg/jsign/archive/refs/tags/5.0.tar.gz"
  sha256 "7b77a12aaea4f404e7b243bd58cfde485eb03b44219e128338c9fe6617ad1fa1"
  license "Apache-2.0"
  head "https://github.com/ebourg/jsign.git", branch: "master"

  depends_on "maven" => :build
  depends_on "openjdk@17" # The build fails with more recent JDKs

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    system "mvn", "--batch-mode", "package",
                  "--projects", "jsign-core,jsign-cli,jsign-ant,jsign",
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
    bin.write_jar_script libexec/"jsign-#{version}.jar", "jsign", args.join(" ")
    bash_completion.install "jsign/src/deb/data/usr/share/bash-completion/completions/jsign"
    man1.install "jsign/src/deb/data/usr/share/man/man1/jsign.1"
  end

  test do
    stable.stage testpath
    res = "jsign-core/src/test/resources"

    system "#{bin}/jsign", "--keystore", "#{res}/keystores/keystore.p12",
                           "--storepass", "password",
                           "#{res}/wineyes.exe"

    system "#{bin}/jsign", "--keystore", "#{res}/keystores/keystore.jks",
                           "--storepass", "password",
                           "#{res}/minimal.msi"

    system "#{bin}/jsign", "--keyfile", "#{res}/keystores/privatekey.pvk",
                           "--certfile", "#{res}/keystores/jsign-test-certificate-full-chain.spc",
                           "--storepass", "password",
                           "#{res}/hello-world.vbs"
  end
end
