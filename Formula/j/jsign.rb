class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https://ebourg.github.io/jsign/"
  url "https://github.com/ebourg/jsign/archive/refs/tags/6.0.tar.gz"
  sha256 "df98690164440627bbecab7498690231c80fb19a68cdf7784b88e19ba24bd7a8"
  license "Apache-2.0"
  head "https://github.com/ebourg/jsign.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24033e21246e7d13267d179314ce519e859cf9bef4285049a652dc8790ff7e56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b8c8a17f4e9d31e48d26de1b4f4b576ea1167e3d9cfb11ba5a61cc6f58a0f23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e345dc02f318332b975d8c9cf046c3bc26d9e896b1fb19889f6970a6fb46c7ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f1d1de5c61a4b3d676736aee2a84ba9165602afeedbb00a85dfc5c90bdd976"
    sha256 cellar: :any_skip_relocation, ventura:       "4e45ee386b5c2d0f48cf9fc0452faa2912f8269dc6e710b3d42da17146d944cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c8d5b9be18eb3997161637c60bc4e22058cde49ef23e5320398fe80c473ef61"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21" # The build fails with more recent JDKs

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
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
