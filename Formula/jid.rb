class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/v0.7.3.tar.gz"
  sha256 "4565030bdf22f831007ecc214fbd14205855b3dff98f7acc8dc6e1f7a2591820"

  bottle do
    cellar :any_skip_relocation
    sha256 "049d37984ecbeba231d96f23caf3dda6ef50dd8a55b91a4e0d62f7975a244c1c" => :mojave
    sha256 "b6de24c980241a14be660440dc9aba403841f5cae50c5aa973bce92ebd1c2081" => :high_sierra
    sha256 "59624c107014497a6596ce33a6344c1456731a2784ffb4e92bf0075ddda16ffa" => :sierra
    sha256 "a77b38789f565878c3dd89b031693fcb35ed60404172a4fb3702b6e0f69f76e5" => :el_capitan
    sha256 "baf231928a3d2c899f3c7ebdfae167cca4b00623def455fb4eca4b0c6ecc7f71" => :yosemite
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
