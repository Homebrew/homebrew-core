class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v2.5.0/apktool_2.5.0.jar"
  sha256 "b392d7cb99b592e9c5acc3c06f1b0f180edde96c66b86b3d6932b7c0c4079fe4"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk@8"

  resource "sample.apk" do
    url "https://github.com/downloads/stephanenicolas/RoboDemo/robodemo-sample-1.0.1.apk"
    sha256 "bf3ec04631339538c8edb97ebbd5262c3962c5873a2df9022385156c775eb81f"
  end

  def install
    libexec.install "apktool_#{version}.jar"
    (libexec/"bin").write_jar_script libexec/"apktool_#{version}.jar", "apktool"
    (libexec/"bin/apktool").chmod 0755
    (bin/"apktool").write_env_script libexec/"bin/apktool", Language::Java.java_home_env("1.8")
  end

  test do
    resource("sample.apk").stage do
      system bin/"apktool", "d", "robodemo-sample-1.0.1.apk"
      system bin/"apktool", "b", "robodemo-sample-1.0.1"
    end
  end
end
