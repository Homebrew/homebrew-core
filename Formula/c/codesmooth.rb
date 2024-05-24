class Codesmooth < Formula
  desc "Command Line Interface for CodeSmooth projects"
  version "1.0.0"
  homepage "https://codesmooth.dev"
  url "https://storage.googleapis.com/codesmooth-resources/public/cli/codesmooth-1.0.0.tar.gz"
  sha256 "e8be488b5f188afa19de35306c31b8393089089d9dea1aac7a9927d6cce74477"

  def install
    bin.install "bin/codesmooth-macos" => "codesmooth"
  end

  test do
    system "#{bin}/codesmooth", "--version"
  end
end
