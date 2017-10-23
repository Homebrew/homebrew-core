class GitRemoteGcrypt < Formula
  desc "PGP-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.0.2.tar.gz"
  sha256 "002994d60d4b3c9a93452d2655bdf3e761c581159431f743d0827127d88f7be2"

  depends_on "docutils" => :build
  depends_on :gpg => :run

  def install
    inreplace "./install.sh", "rst2man", "rst2man.py"

    ENV["prefix"] = prefix

    system "./install.sh"
  end

  test do
    system "false"
  end
end
