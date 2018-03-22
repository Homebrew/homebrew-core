class Goquiet < Formula
  desc "Shadowsocks plugin that obfuscates the traffic"
  homepage "https://github.com/cbeuw/GoQuiet"
  url "https://github.com/cbeuw/GoQuiet/archive/v1.0.2.tar.gz"
  sha256 "bdd7644eb9af4130c5be461b55bb3f3eeb244e2ac2a172208f60e24f662c32c0"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/cbeuw/GoQuiet").install buildpath.children

    cd "src/github.com/cbeuw/GoQuiet" do
      system "make"
      bin.install Dir["build/*"]
    end
  end

  test do
    assert pipe_output("#{bin}/gq-client -h").start_with? ""
    assert pipe_output("#{bin}/gq-server -h").start_with? ""
  end
end
