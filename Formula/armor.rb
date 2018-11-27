class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.4.13.tar.gz"
  sha256 "1e80b70c2fa245800594f3ef7b6bb14d2af4fda2a8622d3c8a0a28f9ef6c4629"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6227d86ce602be4de83e7544e9e2a680828932c0bfadbbaafe553a9a8a31926e" => :mojave
    sha256 "2b30128bcc5d21412b4c2f238c806308bf676d09b61395dd952ebd387f3cc917" => :high_sierra
    sha256 "b5b925484fd1a7835d04e3d9b264d5a3ec600cecade6fcdf8caabb26e2d6f3a9" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
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
      assert_match(/200 OK/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
