class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/0.4.0.tar.gz"
  sha256 "5827d96bab4db88f9c9f3636014ebcb51f9e29677f5587459c972084ed73366e"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c59a861e11672d5e3e0bad2743c015f242c3aa65dc85aeda7460b9d1fa3a267e" => :high_sierra
    sha256 "e6c8b795399edb446ba1d2519cc1b01611a571e78c71a51b1fa9dc993a92189e" => :sierra
    sha256 "10549fb0df601d8a381c700c37e0c5e972508e0fcfff51a8cd1779fbcb9305d2" => :el_capitan
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
