class Carina < Formula
  desc "command-line client for Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        :tag => "v2.1.3",
        :revision => "2b3ec267e298e095d7c2f81a2d82dc50a720e81c"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37e75b5e6b8c8f576b8bde8485e5c6e66ec71b598396d873e6ce005911fcaccb" => :sierra
    sha256 "73297e3bb69192eb07670579834e3339eae96d086dd8995b03277174933bded7" => :el_capitan
    sha256 "83e275ba929845a5fb1512c29655345e60f2022ef93bfa0d4bf2321d2abd6bf4" => :yosemite
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
