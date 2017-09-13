require "language/go"

class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://github.com/miekg/mmark"
  url "https://github.com/miekg/mmark/archive/v1.3.6.tar.gz"
  sha256 "9c49d335d0591003c9ac838f6f74f3ae8e0ac50dec892b6ed3485b17a8bedd77"

  bottle do
    cellar :any_skip_relocation
    sha256 "50097c4c90c9865ab7f4e246931952387b260c6c82a23513d6200ebdab54af32" => :sierra
    sha256 "ba58929bfe0eb4b5c4749b511c0187451ededc5cdd25bdb5e117813a979e5aa3" => :el_capitan
    sha256 "47db5343e91cb6094efa1e6677423a2b907bdaf9b1e61ef28f09b61c7a960397" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "a368813c5e648fee92e5f6c30e3944ff9d5e8895"
  end

  resource "test" do
    url "https://raw.githubusercontent.com/miekg/mmark/master/rfc/rfc1149.md"
    sha256 "f4227951dc7a6ac3a579a44957d8c78080d01838bb78d4e0416f45bf5d99b626"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/miekg/"
    ln_sf buildpath, buildpath/"src/github.com/miekg/mmark"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "mmark" do
      system "go", "build", "-o", bin/"mmark"
    end
  end

  test do
    resource("test").stage do
      system "#{bin}/mmark", "-xml2", "-page", "rfc1149.md"
    end
  end
end
