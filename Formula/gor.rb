require "language/go"

class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/gor/archive/v0.14.1.tar.gz"
  sha256 "802c253fd5218e914e707afb7f3b79baa54871160c4085b949ef3855abfb86d5"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6b3a28bae757f4ac4c63fc8934f3034d13dc63e9baf23f845ab1819cd1d60aa" => :el_capitan
    sha256 "295b1e0975c7d0392f326858ae13dd1c98e77af1f8d67f573c8445b8172aa1c1" => :yosemite
    sha256 "70eb7bdb9269d4b17251f6acc660a4239909eb77cec0341b6ef05b09c2bd1e08" => :mavericks
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
      :revision => "f4807986c9ee46845a35c59a382d6ccd9304b320"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/buger").mkpath
    ln_sf buildpath, buildpath/"src/github.com/buger/gor"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"gor", "-ldflags", "-X main.VERSION=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
