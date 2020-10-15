class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.12.1/nifi-1.12.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.12.1/nifi-1.12.1-bin.tar.gz"
  sha256 "0bb0e24ac5f2f1bb90519cfa24e201fc34346b3bb4d1f79972aeaa2fd4a4bd75"
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
