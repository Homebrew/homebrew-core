class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.14.0.tar.gz"
  sha256 "ac30347c0a1826c37f5f2629a3bd12a4c1cec42428ea15d0d86d56841eaf6998"

  bottle do
    cellar :any_skip_relocation
    sha256 "51b93f40b28c0bdf17e8309113514aae94437e83e23473dca5b586759c6850e8" => :mojave
    sha256 "2f0cb7332fc506b96aab8cb5ec1f331843b4d52b7d9744d0dca1018c462a7418" => :high_sierra
    sha256 "9b48d31e55961df3eb2e938b908012d24888b462a80fe7df19636932104a0117" => :sierra
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
