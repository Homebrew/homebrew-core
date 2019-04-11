class JmeterAT40 < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-4.0.tgz"
  sha256 "845b8325726171a991cc13072275ec64b2ce4bbc6fa8e2aa350b2369e27e76b7"

  keg_only :versioned_formula

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jmeter"
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
