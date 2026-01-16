class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.7.2/nifi-2.7.2-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.7.2/nifi-2.7.2-bin.zip"
  sha256 "64f8a081c6b37f6ea2795500cb99596b5ebe7db461f96655e5b253ed695366e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab1d719dc44e98bd388cdfed9c91914bb24430b5eaa367d4fc0e26d51d83a794"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
