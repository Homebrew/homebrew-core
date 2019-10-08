class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/v0.7.6.tar.gz"
  sha256 "0912050b3be3760804afaf7ecd6b42bfe79e7160066587fbc0afa5324b03fb48"

  bottle do
    cellar :any_skip_relocation
    sha256 "2552c0ab94b892750ecff994b5f3fa963d8ab69298fc27abff7ca92f1e371532" => :mojave
    sha256 "4cfdd2d04b54fdd4d63a1297205bc7867b8bd7049c727ab8ad306c12f0d270d6" => :high_sierra
    sha256 "1905385bc2a0dbd606c4d90f9b119839b3674231ce3b3fa43f0bef314a1684ca" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

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
