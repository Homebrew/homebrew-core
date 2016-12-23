class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/0.6.2.tar.gz"
  sha256 "f74faa04358348a366de4d2ff1ec70c8bf19c385142987889a6d98f04258721a"

  bottle do
    cellar :any_skip_relocation
    sha256 "614f4123c9e8891ba1c30c0fbf047214316ff881d7e964a8568d5858ee4e4e5a" => :sierra
    sha256 "25930dbf57b59917534a4bb93dfa45f051e3864f3063d474859ecae122146be9" => :el_capitan
    sha256 "6e7a89947c15d691e622f2dd637876c21639996df4565c86cff10fdf1d2cca03" => :yosemite
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/simeji/jid").install buildpath.children
    cd buildpath/"src/github.com/simeji/jid" do
      system "go", "get"
      system "go", "build", "-o", bin/"jid", "cmd/jid/jid.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
