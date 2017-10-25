class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/releases/download/v1.9.0/chamber-v1.9.0-darwin-amd64"
  sha256 "723d3ec07ca968f5423b8c7f67a2a5d40e79991f002653c2b3d6cf2784e81154"

  def install
    bin.install Dir["chamber-*"].first => "chamber"
  end

  test do
    system "#{bin}/chamber", "-h"
  end
end
