class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/1.11.3/nifi-1.11.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.11.3/nifi-1.11.3-bin.tar.gz"
  sha256 "8b7fc8e8a6e2af7f7a37212fabbd11664ecd935dd3158e9fc3349f93929fb210"

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
