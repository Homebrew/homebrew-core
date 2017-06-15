class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.3.0.tar.gz"
  sha256 "4435e265d28ea1af094e819eb2fed80906752be5ffd64cdd7b485d93cda490d6"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f73457c9840e6c61dd8f70a958da624316072c08b54afdd49125524760ddbd0" => :sierra
    sha256 "a0e491aa9813b38f1befaeea081d70308ea617757b68162c1599359a10c6e4a0" => :el_capitan
    sha256 "e377e4771d841f2be5bc5ab0a50e3e7d1ef1d08072ca4372a934e0d55cb667ab" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/armor"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
