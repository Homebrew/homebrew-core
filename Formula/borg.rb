require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "http://ok-b.org"
  url "https://github.com/crufter/borg/archive/v0.0.1.tar.gz"
  sha256 "4ee3028a3d6034bcf6f92396f2a7abc9ae562652f886551c33a91cb0fbae835d"

  depends_on "go" => :build

  go_resource "github.com/juju/gnuflag" do
    url "https://github.com/juju/gnuflag.git",
        :revision => "4e76c56581859c14d9d87e1ddbe29e1c0f10195f"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/crufter").mkpath
    ln_s buildpath, buildpath/"src/github.com/crufter/borg"

    system "go", "build", "-o", bin/"borg", "./src/github.com/crufter/borg"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
