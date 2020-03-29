class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.11.4/nifi-1.11.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.11.4/nifi-1.11.4-bin.tar.gz"
  sha256 "5bb68014f818f74b475bcd774ce8c446fc20368ec3062c5ef86e4af9b2ba9aef"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  :NIFI_HOME => libexec,
                                  :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"nifi", "status"
  end
end
