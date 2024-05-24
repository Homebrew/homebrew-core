class Codesmooth < Formula
  desc "Command-line interface for CodeSmooth tasks"
  homepage "https://codesmooth.dev"
  url "https://storage.googleapis.com/codesmooth-resources/public/cli/codesmooth-1.0.0.tar.gz"
  sha256 "087a41437237861f7b49b3d3ab0b64b37efdec52e3843cda253c23a53e6cb9b4"
  license "Apache-2.0"

  def install
    bin.install "bin/codesmooth-macos" => "codesmooth"
  end

  test do
    system "#{bin}/codesmooth", "--version"
  end
end
