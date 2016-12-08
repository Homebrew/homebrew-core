require "language/go"

class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://github.com/miekg/mmark"
  url "https://github.com/miekg/mmark/archive/v1.3.4.tar.gz"
  sha256 "e03744da8d16cc742423685e2ad7cb1af61bf6dc5364c6875057b7c28ab26bb8"

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git", :revision => "443a628bc233f634a75bcbdd71fe5350789f1afa"
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
    system "#{bin}/mmark", "-version"
  end
end
