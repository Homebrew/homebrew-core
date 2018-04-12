class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.6.tar.gz"
  sha256 "1eea2d4ec1945a0b9120bd0bd68a385044740c0c6f2e73a09eefd7a0a001510c"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "406dc653527dbc73e3f3e13200ae1c11f98158f9d70a4952ef4aebfa6bb37439" => :high_sierra
    sha256 "e00cf328830ad7af981da37906ae8de98e13a1f5973f96f1cd534cc982951bc5" => :sierra
    sha256 "206ce1d1dafc268d01a2dc8b1b0b9aa867ffb30af048d3721acd03b372a51909" => :el_capitan
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
