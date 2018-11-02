class Pic2ascii < Formula
  desc "Converts a picture and video to ascii art"
  homepage "https://github.com/wzshiming/pic2ascii"
  url "https://github.com/wzshiming/pic2ascii/archive/v1.5.0.tar.gz"
  sha256 "fe39d6660bcc95c1d24dbfb5d599f18170d9264380fe218f53702a04953f9305"

  depends_on "ffmpeg" => :build
  depends_on "gcc" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    pkg = "github.com/wzshiming/pic2ascii"
    dir = buildpath/"src/#{pkg}/"
    dir.install Dir["*"]
    cd dir do
      system "go", "install", "-v", "-tags=support_video", "./cmd/..."
      prefix.install_metafiles
    end
  end

  test do
    system bin/"pic2ascii", "-f", "https://avatars0.githubusercontent.com/u/6565744", "-w", "80", "-h", "40", "-r"
  end
end
