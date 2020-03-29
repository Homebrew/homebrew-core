class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.4.1/dita-ot-3.4.1.zip"
  sha256 "5db7b883367466de13a4ba3ef36287f082ad5b72e2592dab3fe9a050ec2e3f6c"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat", "config/env.bat", "startcmd.*"]
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
