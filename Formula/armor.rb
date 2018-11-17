class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.4.12.tar.gz"
  sha256 "3c3c51539c2df1973e9a0fece88435ccf0bf1bd7d76c5a7905f6a446535bb5ce"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b33151dd4c356859d9c861ed802f4a2a68281aa6acb31ac310b1db2bdeb419cc" => :mojave
    sha256 "1eb6ccc128ce585652c5f1189cd7a9e93ee2a9bd064c64b3f70e67722976322b" => :high_sierra
    sha256 "7b6376c03caba58a23de9a0027ab1272764a94bc6ed7b9caf879201837843697" => :sierra
    sha256 "cbf3a72453a8585e3bd72b3738f01413b544442c8d635aa0994a99747b39d575" => :el_capitan
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
