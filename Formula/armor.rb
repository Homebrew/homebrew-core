class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.6.tar.gz"
  sha256 "ca2e8761a62e0d59dcd61b25d3fa92496741aebfbf2ea52e1849d86e9141732b"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d417c60b14f66717b259877e5a47ec51eca37050ee85391b69179e18f3444b5b" => :sierra
    sha256 "7bd0929c2be66d126cefebcfbfcd7ea5717e4a965d3013a11c6117e85a8c342e" => :el_capitan
    sha256 "879f87f327cc419f5928aecdaa06e6c2bd1a93aad4fdba2c3824ada32f35a9bf" => :yosemite
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
