require "language/go"

class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/gor.git",
    :tag => "v0.15.0",
    :revision => "ecd7e3a5e508886afd15ed670d72aac5dde9e370"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc9f2415ded76b790d9f27579b71a6d6af7570c49b3c74dd1451a494c0857057" => :el_capitan
    sha256 "9c726a81aefa712a33e3a344761672ebad2d7d51f5ee31a40d95c3f1d1f91ed6" => :yosemite
    sha256 "2c323e895d563fe8c3663ae7ad3e78d6526727917da921b1b0454529c00a3f74" => :mavericks
  end

  depends_on "go" => :build
  go_resource "github.com/google/gopacket" do
    url "https://github.com/google/gopacket.git",
      :revision => "b1af1fa2fcae43d2eef926f31c7acb1c93c6e24f"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/buger/gor").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/buger/gor" do
      system "go", "build", "-o", bin/"gor", "-ldflags", "-X main.VERSION=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
