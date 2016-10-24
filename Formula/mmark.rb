require "language/go"

class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://github.com/miekg/mmark"
  url "https://github.com/miekg/mmark/archive/v1.3.4.tar.gz"
  sha256 "e03744da8d16cc742423685e2ad7cb1af61bf6dc5364c6875057b7c28ab26bb8"

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "443a628bc233f634a75bcbdd71fe5350789f1afa"
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
