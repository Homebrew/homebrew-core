class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v1.4.6/jadx-1.4.6.zip"
  sha256 "1ee8772071095d9393b64031773ea546d85d2196e04626aa212aa651c3e9001c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fdb37bd932d2cfc29073f9cae7aed203ec0a764bd98fca23b488e4052ae14410"
  end

  head do
    url "https://github.com/skylot/jadx.git", branch: "master"
    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  resource "homebrew-sample.apk" do
    url "https://github.com/downloads/stephanenicolas/RoboDemo/robodemo-sample-1.0.1.apk"
    sha256 "bf3ec04631339538c8edb97ebbd5262c3962c5873a2df9022385156c775eb81f"
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
    resource("homebrew-sample.apk").stage do
      system "#{bin}/jadx", "-d", "out", "robodemo-sample-1.0.1.apk"
    end
  end
end
