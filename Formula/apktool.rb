class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v2.4.1/apktool_2.4.1.jar"
  sha256 "bdeb66211d1dc1c71f138003ce35f6d0cd19af6f8de7ffbdd5b118d02d825a52"
  license "Apache-2.0"

  bottle :unneeded

  resource "sample.apk" do
    url "https://github.com/downloads/stephanenicolas/RoboDemo/robodemo-sample-1.0.1.apk"
    sha256 "bf3ec04631339538c8edb97ebbd5262c3962c5873a2df9022385156c775eb81f"
  end

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end

  test do
    resource("sample.apk").stage do
      system bin/"apktool", "d", "robodemo-sample-1.0.1.apk"
      system bin/"apktool", "b", "robodemo-sample-1.0.1"
    end
  end
end
