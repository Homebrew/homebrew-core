class Codesmooth < Formula
  desc "Command Line Interface for CodeSmooth projects"
  version "1.0.0"
  homepage "https://codesmooth.dev"
  url "https://storage.googleapis.com/codesmooth-resources/public/cli/codesmooth-1.0.0.tar.gz"
  sha256 "b80ede38848488ac78e447c3915f503c0273868ccd66c31b2ceb8e9fa135b15c"

  def install
    bin.install "bin/codesmooth-macos" => "codesmooth"
  end

  test do
    system "#{bin}/codesmooth", "--version"
  end
end
