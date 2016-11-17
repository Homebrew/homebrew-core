class GitRemoteGcrypt < Formula
  desc "git remote helper for GPG-encrypted remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://git.spwhitton.name/git-remote-gcrypt.git",
      :tag => "1.0.0",
      :revision => "30b3f5e3356bba404eb630807879b8d4989f8c6e"
  sha256 "9ee9554a7bc627b374e1f80fab4b5539b62b505613c95fdafdc884341ea2cddf"
  head "https://git.spwhitton.name/git-remote-gcrypt.git"

  depends_on "docutils" => :build

  def install
    bin.install "git-remote-gcrypt"
    system "rst2man.py", "README.rst", "git-remote-gcrypt.1"
    man1.install "git-remote-gcrypt.1"
  end

  test do
    system "#{bin}/git-remote-gcrypt"
  end
end
