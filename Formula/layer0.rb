class Layer0 < Formula
  desc "Framework that helps you deploy to the AWS with minimal fuss"
  homepage "http://layer0.ims.io"
  url "https://github.com/quintilesims/layer0/releases/download/v0.10.6/macOS.zip"
  sha256 "5d811660ab7c0590a37125e609796cd0615e937c329aecbb3e462acdfa47b89c"
  depends_on "terraform"
  
  def install
    bin.install "l0"
    bin.install "l0-setup"
    system "echo Install terraform plugin https://github.com/quintilesims/layer0/releases"
  end

  test do
    system "false"
  end
end
