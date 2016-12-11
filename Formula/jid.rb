class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/0.6.2.tar.gz"
  sha256 "f74faa04358348a366de4d2ff1ec70c8bf19c385142987889a6d98f04258721a"

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
