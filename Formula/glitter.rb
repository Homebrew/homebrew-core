class Glitter < Formula
  desc "Git tooling of the future"
  homepage "https://github.com/Milo123459/glitter"
  url "https://github.com/Milo123459/releases/v1.0.0/download/glitter-x86_64-apple-darwin.tar.gz"
  sha256 "aba2e0772b91515a859a8a4ba011a522bc4ce219"
  version "1.0.0"

  def install
    bin.install "glitter"
  end
end
