class Noscl < Formula
  desc "Command line client for Nostr"
  homepage "https://nostr.com/"
  url "https://github.com/fiatjaf/noscl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "35a1fd4ce254a663ac76ff5d671ffa120f95f3161a9b80f2a12beec29ed755db"
  license :public_domain

  depends_on "go" => :build
  
  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build"
    bin.install "noscl" => "noscl"
  end

  test do
    system "noscl", "-h"
  end
end
