class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag => "1.6",
      :revision => "9281665f4106b6c8938904f7ea1ff5386116ca22"
  sha256 "f1627ed11e84890befbf244828aff7a56a17157f721b445804e18b5461e3b8f3"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e71e7b356af33562d6d048d9319c89050146bb33ad5222a3641ee233d2d9474b" => :high_sierra
    sha256 "9d317313b69973d3cd40b03d177c1325f6c8289361642c8dedb1df56ed2e4321" => :sierra
    sha256 "acea265a38c271d3127566b4ded7211a4ca21480d99a680dcf075589b4b53851" => :el_capitan
    sha256 "bafaf993037f0ee03179f9cc7c0d1829a8a64b755ef16429f1bb668ce228c333" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyproto/algernon").install buildpath.children
    cd "src/github.com/xyproto/algernon" do
      system "go", "build", "-o", "algernon"

      bin.install "desktop/mdview"
      bin.install "algernon"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "my.db",
                                "--addr", ":45678"
      end
      sleep 20
      output = shell_output("curl -sIm3 -o- http://localhost:45678")
      assert_match /200 OK.*Server: Algernon/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
