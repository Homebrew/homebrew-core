class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v0.8.0/jadx-0.8.0.zip"
  sha256 "dd02d0dc44a2beb6de5203297875c835332d44bf294db417c20e7bdb267f0c0f"

  head do
    url "https://github.com/skylot/jadx.git"
    depends_on "gradle" => :build
    depends_on :java => "1.8+"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  resource "sample.apk" do
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
    bin.install_symlink libexec/"bin/jadx"
    bin.install_symlink libexec/"bin/jadx-gui"
  end

  test do
    resource("sample.apk").stage do
      system "#{bin}/jadx", "-d", "out", "robodemo-sample-1.0.1.apk"
    end
  end
end
