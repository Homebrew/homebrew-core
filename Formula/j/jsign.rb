class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https://ebourg.github.io/jsign/"
  url "https://github.com/ebourg/jsign/archive/refs/tags/6.0.tar.gz"
  sha256 "df98690164440627bbecab7498690231c80fb19a68cdf7784b88e19ba24bd7a8"
  license "Apache-2.0"
  head "https://github.com/ebourg/jsign.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ac0ba259a072ae54609e8517bef751f0ad9f7dcb39ead1fbf7b529700754420"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b4fb3b4a925e1faacc6bd36e654320bfef7ba2aecafffec465d785f216d4ab8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7419e1205bfa7292c36a90060c73e83d430676776046f483f4ee64db7456c008"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4ec7f9196ccd3fca01c8a2cf28fe274d81968b8f6eb40cfde0639a605716571"
    sha256 cellar: :any_skip_relocation, ventura:        "ef507130f59b62f107d16f75882fd7b23b4b6f85909842712675076dfa4b4669"
    sha256 cellar: :any_skip_relocation, monterey:       "088b5ffdd75d9c8a3d059164646f3f39da3c58bbfbda531b76be0c87d891dec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed7adce83e78177efa6e91e69d9973da4008661c095bf44f39957102c17f535"
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
