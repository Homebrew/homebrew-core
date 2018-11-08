class Gucci < Formula
  desc "Very simple standalone cli templating"
  homepage "https://github.com/noqcks/gucci"
  version "0.1.0"
  url "https://github.com/noqcks/gucci/releases/download/#{version}/gucci-v#{version}-darwin-amd64"
  sha256 "543e4855292d0fe2d425950a0dab31d24f4cf174b6242e058c22c81e22f48cb5"

  bottle :unneeded

  def install
    bin.install "gucci-v#{version}-darwin-amd64" => "gucci"
  end
end

