class Codesmooth < Formula
  desc "Command Line Interface for CodeSmooth projects"
  homepage "https://codesmooth.dev"
  version "1.0.0"
  url "https://storage.googleapis.com/codesmooth-resources/public/cli/codesmooth-1.0.0.tar.gz"
  sha256 "1d6cc5bf9e04d3aa1d3c89f9661d3c123210c7f0a6f7fc349d4e558b15e98e2b"
  license "Apache-2.0"

  def install
    bin.install "bin/codesmooth-macos" => "codesmooth"
  end

  test do
    system "#{bin}/codesmooth", "--version"
  end
end
