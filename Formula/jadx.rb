class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v0.6.0/jadx-0.6.0.zip"
  sha256 "0baa680c8bb4f1c49b6d8b94b3947b8fedf263b5a0c20d3b38da35b57b857228"

  head do
    url "https://github.com/skylot/jadx.git"
    depends_on :java => "1.8+"
    depends_on "gradle" => :build
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  resource "sample.apk" do
    url "https://github.com/downloads/stephanenicolas/RoboDemo/robodemo-sample-1.0.1.apk", :using => :nounzip
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
