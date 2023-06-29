class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.22.0/nifi-1.22.0-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.22.0/nifi-1.22.0-bin.zip"
  sha256 "9793f5548978d35679801ce5d934073b0d48057f402f401347f78777bae60eb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "891379f0718c5cb16793818a86815e5c9357ca21b1676d23bb47bd11555c9acf"
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
