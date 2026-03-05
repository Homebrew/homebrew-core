class Chunk < Formula
  desc "CircleCI's Chunk CLI"
  homepage "https://github.com/CircleCI-Public/chunk-cli"
  version "0.6.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/CircleCI-Public/chunk-cli/releases/download/v0.6.2/chunk-cli_Darwin_x86_64.tar.gz"
      sha256 "cb585222e49666edb2aed8f958a05109dfb2733804dfb5a33ed1b7d10225a21f"

      define_method(:install) do
        bin.install "chunk"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/CircleCI-Public/chunk-cli/releases/download/v0.6.2/chunk-cli_Darwin_arm64.tar.gz"
      sha256 "2c5a46f8a94e8c3a97b02e4575c81f540471aee94e577131a4c7a5018da2b062"

      define_method(:install) do
        bin.install "chunk"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/CircleCI-Public/chunk-cli/releases/download/v0.6.2/chunk-cli_Linux_x86_64.tar.gz"
      sha256 "9cf002cba4458e583f126f5ee2163b2b073a59a34d3516169762d5969f70f9be"

      define_method(:install) do
        bin.install "chunk"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/CircleCI-Public/chunk-cli/releases/download/v0.6.2/chunk-cli_Linux_arm64.tar.gz"
      sha256 "92f5e3a9c7b3d6617010de41fb4db0d84e30ddcb8326796f2c8ccc9359b0e146"

      define_method(:install) do
        bin.install "chunk"
      end
    end
  end

  test do
    output = shell_output("#{bin}/chunk 2>&1")
    assert_match(/chunk|usage|command|version/i, output)
  end
end
