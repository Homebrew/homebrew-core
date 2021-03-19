class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.13.1/nifi-1.13.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.13.1/nifi-1.13.1-bin.tar.gz"
  sha256 "879aff54cc8909c722158aced0bf1c20a0e8ef4d717b3e4e4d26405efee6336b"
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
