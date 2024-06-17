class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v1.5.0/jadx-1.5.0.zip"
  sha256 "c5a713fa4800cbb9e6df85ced1bef95ba329040c95cb87d54465f108483e4ef9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78db5c2318306279313ded903663c847c20630057f12096eb62bdf5e1b49299a"
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
