class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.4/minipro-0.4.tar.gz"
  sha256 "05e0090eab33a236992f5864f3485924fb5dfad95d8f16916a17296999c094cc"

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "minipro"
  end

  test do
    output = shell_output("#{bin}/minipro 2>&1")
    assert_match "minipro version", output
  end
end
