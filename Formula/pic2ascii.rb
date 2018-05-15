class Pic2ascii < Formula
  desc "Converts a picture and video to ascii"
  homepage "https://github.com/wzshiming/pic2ascii"
  url "https://github.com/wzshiming/pic2ascii/archive/v1.4.3.tar.gz"
  sha256 "15d9d21399ac3560b9d919b7d643d74c9c82bde5942e4d0ebed06109dd9236ae"

  depends_on "ffmpeg" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/wzshiming/pic2ascii/"
    dir.install Dir["*"]
    cd dir do
      system "go", "build", "-tags=support_video", "-o", bin/"pic2ascii", "./cmd/pic2ascii"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"pic2ascii", "-f", "https://avatars0.githubusercontent.com/u/6565744", "-w", "80", "-h", "40", "-r", "-t", "gif"
  end
end
