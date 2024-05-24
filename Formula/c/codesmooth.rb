class Codesmooth < Formula
  desc "Command-line interface for CodeSmooth tasks"
  homepage "https://codesmooth.dev"
  url "https://storage.googleapis.com/codesmooth-resources/public/cli/codesmooth-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "a91d85198ae2f7bc4b4a797acd608fcddebc779b4f1a77c38844b724ef08dcfa"
  license "Apache-2.0"

  def install
    bin.install "bin/codesmooth-macos" => "codesmooth"
  end

  test do
    system "#{bin}/codesmooth", "--version"
  end
end
