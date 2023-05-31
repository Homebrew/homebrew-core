class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https://ebourg.github.io/jsign/"
  url "https://github.com/ebourg/jsign/archive/refs/tags/4.2.tar.gz"
  sha256 "653ce9626969ddcbf3365dee54c25c53586bdf3f5d9a067991e07121dd127bee"
  license "Apache-2.0"

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    system("mvn", "--batch-mode", "package", "--projects", "jsign-core,jsign-cli,jsign-ant,jsign", "-DskipTests",
           "-Djdeb.skip", "-Dmaven.javadoc.skip")

    libexec.install Dir["jsign/target/jsign-#{version}.jar"]
    bin.write_jar_script libexec/"jsign-#{version}.jar", "jsign", "-Djava.net.useSystemProxies=true -Dbasename=jsign -Dlog4j2.loggerContextFactory=net.jsign.log4j.simple.SimpleLoggerContextFactory"
    bash_completion.install "jsign/src/deb/data/usr/share/bash-completion/completions/jsign" => "jsign"
    man1.install "jsign/src/deb/data/usr/share/man/man1/jsign.1"
  end

  test do
    system "#{bin}/jsign", "--help"
  end
end
