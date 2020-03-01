class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.3.tar.gz"
  sha256 "e1948dda848db845db404e4337b07206c96cb239b66392fd1c9c246279c2cb25"

  bottle do
    cellar :any_skip_relocation
    sha256 "723f849079d609d6b77d6b1a34065caf46ded851c817dc0466909f02f7d81b4b" => :catalina
    sha256 "c0d744c949262d994256378e22a45789cbaaead577fc6d4d46fd9a87b87ae903" => :mojave
    sha256 "91d4ddeb8c3840a2a647f2aca1cf03723f1f459b7ecddaa5f6f391ba9c96d843" => :high_sierra
  end

  depends_on "docutils" => :build

  def install
    ENV["prefix"] = prefix
    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output("#{bin}/git-remote-gcrypt", "capabilities\n", 0))
  end
end
