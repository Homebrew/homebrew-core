class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.10.0/nifi-2.10.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.10.0/nifi-2.10.0-bin.zip"
  sha256 "46709e6550e4235fe821c537e26538e31bb0e038153519a69ba33d3e9e2f8641"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3296a48ca38e8d286f457150049d4e36734d0a03f1c62905775446b510bd3c61"
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
