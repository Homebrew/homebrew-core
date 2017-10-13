class Circle < Formula
  desc "Command-line client for CircleCI"
  homepage "https://github.com/kevinburke/go-circle"

  url "https://github.com/kevinburke/go-circle/releases/download/0.25/circle-darwin-amd64"
  version "0.25"
  sha256 "c481df9024a8f143e4e05913eacd39b23cdc2b3ff6c344b8b074c4af61534b25"

  def install
    bin.install "circle-darwin-amd64" => "circle"
  end

  test do
    assert_match "circle version 0.25", shell_output("#{bin}/circle version 2>&1", 1)
  end
end
