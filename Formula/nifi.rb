class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.15.0/nifi-1.15.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist//nifi/1.15.0/nifi-1.15.0-bin.tar.gz"
  sha256 "5d0e815fabc1e9767a5379e96074b4eeb1b0a290797bee453a33ad4f8d2ece92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8ccb25a04665f032c60879a5ffe204cba9c82ba0a33ae7a5918c56e7b3abf1e1"
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
