class PullVids < Formula
  desc "Universal video downloader CLI supporting 1000+ websites"
  homepage "https://github.com/vib795/pull-vids"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "yt-dlp"

  on_macos do
    on_arm do
      url "https://github.com/vib795/pull-vids/releases/download/v0.2.0/pull-vids-darwin-arm64.tar.gz"
      sha256 "710d1e1d3cec52d8a63f217b158d9ce3b1dadf24f537e9eec61391ae95047c2d"
    end
    on_intel do
      url "https://github.com/vib795/pull-vids/releases/download/v0.2.0/pull-vids-darwin-amd64.tar.gz"
      sha256 "840e34c090cd9faff70a2c7afd0607c0efc6e0eb7f1088e70955e7af40e7c17c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vib795/pull-vids/releases/download/v0.2.0/pull-vids-linux-arm64.tar.gz"
      sha256 "72839942b54bee8c74b2691e78fae00a6fb704c5e44af4d80b8c04dff91dbac6"
    end
    on_intel do
      url "https://github.com/vib795/pull-vids/releases/download/v0.2.0/pull-vids-linux-amd64.tar.gz"
      sha256 "aed88f543f74c4f9459a8f8d61857eaf520c0e100c8e1e8d9e37577478ae9e1b"
    end
  end

  def install
    # Determine the correct binary name based on platform and architecture
    binary_name = if OS.mac?
      Hardware::CPU.arm? ? "pull-vids-darwin-arm64" : "pull-vids-darwin-amd64"
    else
      Hardware::CPU.arm? ? "pull-vids-linux-arm64" : "pull-vids-linux-amd64"
    end

    bin.install binary_name => "pull-vids"
  end

  test do
    # Test version output
    version_output = shell_output("#{bin}/pull-vids --version")
    assert_match "pull-vids", version_output

    # Test help output
    help_output = shell_output("#{bin}/pull-vids --help 2>&1")
    assert_match "Universal Video Downloader", help_output
    assert_match "Supports 1000+ sites", help_output
  end
end
