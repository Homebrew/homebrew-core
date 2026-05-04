class Apesdk < Formula
  desc "Command-line Simulated Ape simulation from the ApeSDK"
  homepage "https://github.com/barbalet/apesdk"
  url "https://github.com/barbalet/apesdk/releases/download/v0.708/apesdk-0.708.tar.gz"
  sha256 "89dcac7d04986a207a3a53901456e17af7b37ff82a202d46c2791fc2345e522b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  uses_from_macos "zlib"

  def install
    system "./build.sh", "--output", "simape"
    bin.install "simape"
  end

  test do
    assert_match "Simulated Ape 0.708", shell_output("#{bin}/simape --version")
    assert_match "simape self-test OK", shell_output("#{bin}/simape --self-test")
  end
end
