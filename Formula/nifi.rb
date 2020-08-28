class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.12.0/nifi-1.12.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.12.0/nifi-1.12.0-bin.tar.gz"
  sha256 "e2ddbc1b57d88e1e154c40d2c533b42ff37275bed1d71a392eb2fa111511651b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  NIFI_HOME: libexec,
                                  JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"nifi", "status"
  end
end
