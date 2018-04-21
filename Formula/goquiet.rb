require "language/go"

class Goquiet < Formula
  desc "Shadowsocks plugin that obfuscates the traffic"
  homepage "https://github.com/cbeuw/GoQuiet"
  url "https://github.com/cbeuw/GoQuiet/archive/v1.1.1.tar.gz"
  sha256 "55f92df1dcf892d7aaccd0331d917a41286dafb5a7d8fa7b8d2d257dc385314f"

  depends_on "go" => :build

  go_resource "github.com/cbeuw/gotfo" do
    url "https://github.com/cbeuw/gotfo.git",
        :revision => "e8588a8e0499d45affbdedf940842dbfb2805cd0"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/cbeuw").mkpath
    ln_s buildpath, "src/github.com/cbeuw/GoQuiet"

    system "make"
    bin.install Dir["build/*"]
    prefix.install_metafiles
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/gq-client -h 2>&1", 2)
    assert_match "Usage of", shell_output("#{bin}/gq-server -h 2>&1", 2)
  end
end
