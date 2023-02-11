class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.20.0/nifi-1.20.0-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.20.0/nifi-1.20.0-bin.zip"
  sha256 "2279a507a282de1812dc990a6573f3912a3d0cd734b9955628d206a76f3896c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4559bc862f9d1e1838feb2c9c84748b1f81ef43bc7ee3e81af13cfbc4fb35693"
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
