class Gotiny < Formula
  desc "Using gotiny.cc from the command-line"
  homepage "https://github.com/ndthanhdev/gotiny-cli"
  version "1.0.6"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ndthanhdev/gotiny-cli/releases/download/v1.0.6/gotiny-v1.0.6-darwin-arm64"
      sha256 "3572e5b7dccad80c38a939b9dc96a52d289c24a92f8a8882b049bef5c54ffc2b"
    else
      url "https://github.com/ndthanhdev/gotiny-cli/releases/download/v1.0.6/gotiny-v1.0.6-darwin-amd64"
      sha256 "164320ec0dd55bc3cd0474cca5641dc38816473a0be3d767ed7d89fbdce3dd46"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/ndthanhdev/gotiny-cli/releases/download/v1.0.6/gotiny-v1.0.6-linux-arm64"
      sha256 "bf1a6ad55d795f0fcff39762940146945a5a549a3f2535ff8cb1db83d7841f22"
    elsif Hardware::CPU.arm?
      url "https://github.com/ndthanhdev/gotiny-cli/releases/download/v1.0.6/gotiny-v1.0.6-linux-arm"
      sha256 "30191bd89d9c129cd1b5b12e6e9c5372c5121882ca2c2a5658e7df0e71293691"
    elsif Hardware::CPU.is_64_bit?
      url "https://github.com/ndthanhdev/gotiny-cli/releases/download/v1.0.6/gotiny-v1.0.6-linux-amd64"
      sha256 "512e33ab74d3ec394cdca93c8f16f918cb2156e0598f794e78b3b0e9b7d8fbf5"
    else
      url "https://github.com/ndthanhdev/gotiny-cli/releases/download/v1.0.6/gotiny-v1.0.6-linux-386"
      sha256 "c683d5216bc6a9b73ea7c8f4019912096a39bcd5df660abd9d092576edcca208"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "gotiny-v1.0.6-darwin-arm64" => "gotiny"
      else
        bin.install "gotiny-v1.0.6-darwin-amd64" => "gotiny"
      end
    end

    if OS.linux?
      if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
        bin.install "gotiny-v1.0.6-linux-arm64" => "gotiny"
      elsif Hardware::CPU.arm?
        bin.install "gotiny-v1.0.6-linux-arm" => "gotiny"
      elsif Hardware::CPU.is_64_bit?
        bin.install "gotiny-v1.0.6-linux-amd64" => "gotiny"
      else
        bin.install "gotiny-v1.0.6-linux-386" => "gotiny"
      end
    end
  end

  test do
    system bin/"gotiny", "--version"
  end
end
