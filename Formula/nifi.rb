class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.18.0/nifi-1.18.0-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.18.0/nifi-1.18.0-bin.zip"
  sha256 "f8eaf0b805e3094682da668f1097ccd98deec35240c677c2089cb486d69f0b64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "959c1443a3b6a47dc3a7e76b131d9b4efa2def72e433165042a5e4fb510b9b8e"
  end

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
