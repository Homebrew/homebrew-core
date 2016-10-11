class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v1.5.0",
        :revision => "2d7f5c0afe28a3e9e794c99ce5024be283979e71"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0ae150b4c1e75a87c5e8c245c3563dd3c9e2862019e8cee45e19282cdcfd43ec" => :sierra
    sha256 "f7f1e834d7fd4e45c478132dacb1727690b7a85e13a83c41eb85dc5983f3374c" => :el_capitan
    sha256 "332a4d4c2790de14eef2973b82f5576681b04d5f90731f9ad3a1897d8f20a2a2" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    carinapath = buildpath/"src/github.com/getcarina/carina"
    carinapath.install Dir["{*,.git}"]

    cd carinapath do
      system "make", "get-deps"
      system "make", "carina", "VERSION=#{version}"
      bin.install "carina"
    end
  end

  test do
    system "#{bin}/carina", "--version"
  end
end
