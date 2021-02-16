class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.13.0/nifi-1.13.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.13.0/nifi-1.13.0-bin.tar.gz"
  sha256 "bc3f86afbf54c08329bff64c1d3cbcba629a547b4e71cd2c1e0dcb98885dcd11"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
