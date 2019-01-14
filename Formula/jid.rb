class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/v0.7.3.tar.gz"
  sha256 "4565030bdf22f831007ecc214fbd14205855b3dff98f7acc8dc6e1f7a2591820"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe863d058029cd05bfbab6e4cb4c047bacf083e384107bae392cd19f98fa838f" => :mojave
    sha256 "b56ab5691802bef1c9208bceb5033c7c0189039d51cbba8d76340bc6201a0a5c" => :high_sierra
    sha256 "26f30466774f05ac96a24d8a3210d36bbf2c17fbce36734beca7a6e91afa7e34" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    src = buildpath/"src/github.com/simeji/jid"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"jid", "cmd/jid/jid.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
