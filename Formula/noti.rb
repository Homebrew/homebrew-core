class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.2.0.tar.gz"
  sha256 "3acb1cb0c352e6387b172867e5187f9241b66f9104d95c93ad8dc9a908937626"

  bottle do
    cellar :any_skip_relocation
    sha256 "86798629e20bc7b956fb0912b6bc1dc2e4a28e94f2052aa53fe091f8f9eab05a" => :el_capitan
    sha256 "dfca3b3386417fc3b3f80fb2ce871324fccba2b8cfc067a7ed2a24580bc3f70c" => :yosemite
    sha256 "b5bec6039469988873fa2445a1c9662cb7982af690d4f21e1b88c0b7022cbd0e" => :mavericks
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
