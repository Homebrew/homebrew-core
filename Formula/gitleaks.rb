class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/releases/download/v1.24.0/gitleaks-darwin-amd64"
  version "1.24.0"
  sha256 "f81d98a002b85a12abb6d6441736c95a7ef416c97d9fbd55113ff380913146f3"

  def install
    bin.install "gitleaks-darwin-amd64" => "gitleaks"
  end

  test do
    system "#{bin}/gitleaks", "-v"
  end
end
