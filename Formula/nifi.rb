class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/1.11.1/nifi-1.11.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.11.1/nifi-1.11.1-bin.tar.gz"
  sha256 "b0b35a9db0e6c8c299ca174e668acf8389488976b1674f08771f9361d884c5f3"
  revision 1

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
