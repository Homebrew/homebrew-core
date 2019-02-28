class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.12.0.tar.gz"
  sha256 "9b9a05452c23ccc94676e2e6b86f57805262496b14b6ec018df08996131eeec5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec46d028c3f11c33501e9aedff0604d9ab427f7da404c567ea6c89f449fe3bc4" => :mojave
    sha256 "d94765d82109056304f649de3c3aa8978b0872f8ad9d8eb124ef94725136c7cc" => :high_sierra
    sha256 "5c3ade533c8ef6596a33ce7a3b600ef5981aee08f9a1b22d7daa6d335a5fbcc5" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
