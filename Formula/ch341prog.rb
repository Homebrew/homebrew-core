class Ch341prog < Formula
  desc "CLI tool for interfacing with ch341a USB SPI/IIC programmer"
  homepage "https://github.com/setarcos/ch341prog"
  url "https://github.com/setarcos/ch341prog.git", :using => :git, :tag => "v1.0b", :revision => "ac51c1ea52b9046ac634f052290b7036a49aff13"
  version "1.0b"
  sha256 "390c7db7a27078f9b75fba55d61a8502842b3abe779b4a184bee13e461eb1a7c"

  depends_on "libusb"

  def install
    bin.install "ch341prog"
  end

  test do
    system "#{bin}/ch341prog", "--help"
  end
end
