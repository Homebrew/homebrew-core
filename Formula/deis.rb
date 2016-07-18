class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.13.2.tar.gz"
  sha256 "3e583cc0af91fa617b1b732acd38beb8c094cfcd511af19ebac949533c981e2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "99001d66871f738fb68b5bc7514bf7a8ee759516cc0cbec6d47f0dbb5e3196b6" => :el_capitan
    sha256 "d94a1a91d61bcb9a9c4c2d3696eeb1fb5b51993c96d9c2c8bd83913e901fc441" => :yosemite
    sha256 "2fe7be530f9f863f0be4be8204b1b299e68c1bad105bd353d2bff0a05f8d503a" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deis", "client/deis.go"
  end

  test do
    system bin/"deis", "logout"
  end
end
