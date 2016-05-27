require "language/go"

class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.2.0.tar.gz"
  sha256 "3acb1cb0c352e6387b172867e5187f9241b66f9104d95c93ad8dc9a908937626"

  bottle do
    cellar :any_skip_relocation
    sha256 "d35a463a362591ce41b9e609071ed876ffaa5c9540f2393a2e6bc0a20f97eea8" => :el_capitan
    sha256 "f5cc202358c1a7409b66ec9b3b3b411fbe2b9caccbd7746ec20beb70afdfc238" => :yosemite
    sha256 "5d655704e9f39feba5b6cf26a74be4a4dcf3bf337d18d0c0652ff4bfa2693012" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    notipath = buildpath/"src/github.com/variadico/noti"
    notipath.install Dir["*"]

    cd "src/github.com/variadico/noti/cmd/noti" do
      system "go", "build"
      bin.install "noti"
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
