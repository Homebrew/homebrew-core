class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.2.tar.gz"
  sha256 "6f00d5891639f8d2c263ca15b14ad02bb5a8dd048e9c778fcc12a38cb26f51c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "723f849079d609d6b77d6b1a34065caf46ded851c817dc0466909f02f7d81b4b" => :catalina
    sha256 "c0d744c949262d994256378e22a45789cbaaead577fc6d4d46fd9a87b87ae903" => :mojave
    sha256 "91d4ddeb8c3840a2a647f2aca1cf03723f1f459b7ecddaa5f6f391ba9c96d843" => :high_sierra
  end

  depends_on "docutils" => :build

  def install
    inreplace "./install.sh", "rst2man", "rst2man.py"
    ENV["prefix"] = prefix
    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output("#{bin}/git-remote-gcrypt", "capabilities\n", 0))
  end
end
