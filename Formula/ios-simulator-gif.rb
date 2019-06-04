class IosSimulatorGif < Formula
  desc "Record a gif from your iOS simulator in a jiffy"
  homepage "https://github.com/fjcaetano/ios-simulator-gif"
  url "https://github.com/fjcaetano/ios-simulator-gif/archive/0.0.1.tar.gz"
  sha256 "41e51c8a4d9dc21746d9ee01b956d245e156f636026c9ad01aa26bb7e738ed9b"

  depends_on "ffmpeg"

  def install
    bin.install "bin/ios-simulator-gif"
  end

  test do
    system "which", "ios-simulator-gif"
  end
end
