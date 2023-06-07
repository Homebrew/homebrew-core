class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.21.0/nifi-1.21.0-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.21.0/nifi-1.21.0-bin.zip"
  sha256 "c384778a66be744231ea2e076d014d2bc4bfb2a214e810857e39b1da90336e7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf6bbac6f9cf9a5f00d01d56c9404d076652a397de80fd1c085c7c18355df5f3"
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
