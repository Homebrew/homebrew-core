class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v2.6.1/apktool_2.6.1.jar"
  sha256 "bc2b9a87ac5a86905b6ca343c21a0db3bc37bdd51154bc9cdf65523d95895d34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd6c85028454c8a6ec977fcdd9b22fea21cf9abbc13590255b1796e119130e32"
  end

  depends_on "openjdk"

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
