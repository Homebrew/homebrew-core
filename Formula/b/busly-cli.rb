class BuslyCli < Formula
  desc "Unofficial CLI for NServiceBus"
  homepage "https://tragiccode.com/busly-cli/"
  url "https://github.com/tragiccode/busly-cli/releases/download/v0.35.0/busly-cli-v0.35.0-osx-arm64.tar.gz"
  version "0.35.0"
  sha256 "fb4884128ff2c6efbb011bd6ee56fca0edf141d0fa13f5ec40f44277060b3285"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      # URL already points to ARM binary
    end
  end

  def install
    # Rename the binary so users type 'busly' instead of 'Busly.Console'
    bin.install "Busly.Console" => "busly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/busly --version")
  end
end
