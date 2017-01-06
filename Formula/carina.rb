class Carina < Formula
  desc "command-line client for Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v2.0.1",
        :revision => "15e3e772a56553e563598288be720c703c4166e6"
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
    ENV.prepend_create_path "PATH", buildpath/"bin"

    carinapath = buildpath/"src/github.com/getcarina/carina"
    carinapath.install Dir["{*,.git}"]

    cd carinapath do
      system "make", "get-deps"
      system "make", "local", "VERSION=#{version}"
      bin.install "carina"
    end
  end

  test do
    system "#{bin}/carina", "--version"
  end
end
