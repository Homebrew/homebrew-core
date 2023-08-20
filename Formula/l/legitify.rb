class Legitify < Formula
  desc "Legitify - open source scm scanning tool by Legit Security"
  homepage "https://github.com/Legit-Labs/legitify"

  on_intel do
    url "https://legitify.legitsecurity.com/1.0.1/darwin/amd64.tar.gz"
    sha256 "bec5ca356681a29e659658a569472baef638503b74f67de4f391a620e5c6e284"
    version "1.0.1"
  end 
  on_arm do
    url "https://legitify.legitsecurity.com/1.0.1/darwin/arm64.tar.gz"
    sha256 "6d8e182cade90431cda7a9cd475b59219cea29ffced075505596a8970b759732"
    version "1.0.1"
  end

  def install
    bin.install "legitify"
  end
  test do
    assert match version.to_s, shell_output("#{bin}/legitify version 2>&1")
  end
end
