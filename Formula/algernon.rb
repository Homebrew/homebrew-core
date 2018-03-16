class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag => "1.8",
      :revision => "93349dfc4d3daa5351c51551e8a8b9f0633bdc90"
  sha256 "f1627ed11e84890befbf244828aff7a56a17157f721b445804e18b5461e3b8f3"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e65a775e548ae38c67c3239ff74c103221da38f955b25b1d85663e9e37808256" => :high_sierra
    sha256 "40c63d30da16700fb699ae1131090bc022e63c8dd90c60c0a4b0943383fd69e3" => :sierra
    sha256 "c4363693589de0212eafa752a271e738e9d4f2082e267576e4627077b14f0a12" => :el_capitan
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
        exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
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
