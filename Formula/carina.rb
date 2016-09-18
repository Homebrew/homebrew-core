class Carina < Formula
  desc "Work with Swarm clusters on Carina"
  homepage "https://github.com/getcarina/carina"
  url "https://github.com/getcarina/carina.git",
        tag: "v1.5.0",
        revision: "621b6ecc9d34bad00b016a9829210b33fd4f2355"
  head "https://github.com/getcarina/carina.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0174a64dff68ea9d0f7df1d758e876bc1ee2481caf42f92244024c975af3ab86" => :el_capitan
    sha256 "0a15e8d5a9fd01fc009e7a6485b3a911d273e599a653a33bd7fb2f8f0fc29d46" => :yosemite
    sha256 "83c57e27421c21676fdf7247a941bcd2723360f8b44138ed37079f9cfb679292" => :mavericks
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
