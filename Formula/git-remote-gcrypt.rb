class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.2.tar.gz"
  sha256 "6f00d5891639f8d2c263ca15b14ad02bb5a8dd048e9c778fcc12a38cb26f51c4"

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
