require "language/go"

class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/gor.git",
      :tag => "v0.13.0",
      :revision => "98fe7f19b21eaaffcd0d733a57668f63de5921d7"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f552482322a1f17d656f4079509cfe4e2ed44a02d0270bc842fb7d71c1140ed" => :el_capitan
    sha256 "33c2c144336309b25f877c18d5daa69b7948ad20c505da4832135d77629ee880" => :yosemite
    sha256 "06d1905b52b0d9b6ea0ee983e4d1981a9070ffe06b80b2488ef1fe4e2f654522" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git",
      :revision => "d0e59c22a56e8dadfed24f74f452cea5a52722d2"
  end

  go_resource "github.com/buger/elastigo" do
    url "https://github.com/buger/elastigo.git",
      :revision => "23fcfd9db0d8be2189a98fdab77a4c90fcc3a1e9"
  end

  go_resource "github.com/google/gopacket" do
    url "https://github.com/google/gopacket.git",
      :revision => "aa09ced736460d76535444c825932a0742975f7d"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/buger/"
    ln_sf buildpath, buildpath/"src/github.com/buger/gor"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/gor", "-ldflags", "-X main.VERSION \"#{version}\""
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
