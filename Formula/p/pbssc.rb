class Pbssc < Formula
  desc "You can get the device image from the CLI and copy it to the clipboard"
  homepage "https://github.com/sakebook/pbssc"
  url "https://github.com/sakebook/pbssc/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "184230da10caf36922a27e18eeed66e91c52fc0065cb91ef9fac60a34501ab13"
  license "Apache-2.0"

  def install
    bin.install "pbssc"
  end

  test do
    ENV["PBSSC_IMAGE_PATH"] = testpath/"dummy_image_path"
    system bin/"pbssc", "-h"
  end
end
