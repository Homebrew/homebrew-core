class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  license "MIT"

  version "0.1.50"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/iximiuz/labctl/releases/download/v0.1.50/labctl_darwin_arm64.tar.gz"
      sha256 "6d4209f50f7cc1ae33bc2d492ffb5d2dd9083475dfc7d787c45e08acc2ca5ad1"
    else
      url "https://github.com/iximiuz/labctl/releases/download/v0.1.50/labctl_darwin_amd64.tar.gz"
      sha256 "274ea09f6d93a5d0bf35b7767b842d6bbc9c5199ef9fd1dd324ba3c7fa0e1601"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/iximiuz/labctl/releases/download/v0.1.50/labctl_linux_arm64.tar.gz"
      sha256 "df136bb19c164e6828fce045114708ee5170e053c756b5a410e1c6c6deeb74da"
    else
      url "https://github.com/iximiuz/labctl/releases/download/v0.1.50/labctl_linux_amd64.tar.gz"
      sha256 "34f4f9c3643e37f2fabf26b01620d7f0b7bed34481ad9e1869a017478b356f4b"
    end
  end

  def install
    bin.install "labctl"
  end

  test do
    assert_match "labctl", shell_output("#{bin}/labctl --help")
  end
end