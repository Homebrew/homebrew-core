class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-1.4.7.zip"
  sha256 "a13d2be02ed640de54df937ead680f31ea06f4b8efd01860b9f0cf18a7d40e34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "035de90325e1e3b294a15302ef229b1f26cd8c255d2fa4b8ce335b59afca6c48"
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
      system "#{bin}/jadx", "-d", "out", "redex-test.apk"
    end
  end
end
