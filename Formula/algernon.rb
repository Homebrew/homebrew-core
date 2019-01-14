class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag      => "1.12.1",
      :revision => "26b9b39868ee55866e2bec551adc0627dc79d18b"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f321c973abf840aa4b692492688a08e10311c8f6b1a5125e3523b5ccf81d34d8" => :mojave
    sha256 "0c8cfec27830be68fcd5032fcbec444f8fbf963e089c264d1e570cc0ddc9d020" => :high_sierra
    sha256 "0d132a8e624b56ccaaa47e808fc22e080e522e1e972bde0df8f40d0d6352c3c0" => :sierra
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
