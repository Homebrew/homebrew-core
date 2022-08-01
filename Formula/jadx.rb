class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v1.4.3/jadx-1.4.3.zip"
  sha256 "0613cd21ab407297794c2e7e99fdebb45cec27ea5785e79a7cc538146ad68f84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99fca6b04b3427000fbb4905845a43a3201809156a048dff12c3df8d2303f0d0"
  end

  head do
    url "https://github.com/skylot/jadx.git"
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
