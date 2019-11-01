class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.0.1.tar.gz"
  sha256 "8207bb796727019b277f63c709fa4e399f2d40c223633d0df6c74dc1f3c9385f"
  head "https://github.com/google/oauth2l.git"

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    system "#{bin}/oauth2l", "-h"
  end
end
