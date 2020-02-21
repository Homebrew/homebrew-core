class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.11.2/nifi-1.11.2-bin.tar.gz"
  sha256 "950a58c9aca9c1f3594c21d01e76e63d538471e44d2291ce5bd01989d3a8ee27"

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
