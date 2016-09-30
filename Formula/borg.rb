class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "http://ok-b.org"
  url "https://raw.githubusercontent.com/crufter/borg/v0.0.1/main.go"
  version "0.0.1"
  sha256 "6133cd8948b51ab90d0faa4b7f1e548fddacfcb4747be168e8ec5ef3e753fdde"

  depends_on "go" => :build

  def install
    system "go", "build", "main.go"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
