class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v1.5.1/jadx-1.5.1.zip"
  sha256 "12fd966431903b8e15c36e5007f19343475be7d8f2a55f082e7a929eeabc937e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "735427c63f8e20f067a5a50d4273cea56b5fd528bb0ad656d91a76762e774997"
  end

  head do
    url "https://github.com/skylot/jadx.git", branch: "master"
    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  resource "homebrew-test.apk" do
    url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    if build.head?
      system "gradle", "clean", "dist"
      libexec.install Dir["build/jadx/*"]
    else
      libexec.install Dir["*"]
    end
    bin.install libexec/"bin/jadx"
    bin.install libexec/"bin/jadx-gui"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    resource("homebrew-test.apk").stage do
      system bin/"jadx", "-d", "out", "redex-test.apk"
    end
  end
end
