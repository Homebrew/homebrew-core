class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https://ebourg.github.io/jsign/"
  url "https://github.com/ebourg/jsign/archive/refs/tags/5.0.tar.gz"
  sha256 "7b77a12aaea4f404e7b243bd58cfde485eb03b44219e128338c9fe6617ad1fa1"
  license "Apache-2.0"
  head "https://github.com/ebourg/jsign.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67e85c4ba9ad0a084c568deb11c2eadcaaa143699824bceca3466ce56723cdbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3c8696ed5589fe3b66b01b6c049ab9f49a3e81fe0fd3efe671e4187e30824ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2274a1daceded682726c51bb0e55567ff59c1ce526a9494b37c0cf668a1b559a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6271342afec98071599b74af7c900bc6bb200da69d0d149b5a71b7e845d70e0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aa17dfd04c712b81e2384fd16222e48f5518c983fbea60c1eca97edc49deaa9"
    sha256 cellar: :any_skip_relocation, ventura:        "69fe2bb7930593d71f86377523387a05cbde3b45e56204e9f862f234c4bf7fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "5b6a5ba3eeff3b9ae4e8ae8b916da3cb71e606f07ae9fef2f53f43d2982ddb88"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf37117fca040abbadb8d4d534eaf29d843e80deabcb9ad254a6f8dbc6ca874f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8f72976289410f0c649fc16494b354ea88a61fd270cf4d6b4ecaa29b4f10abb"
  end

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
