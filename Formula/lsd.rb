class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.11.1.tar.gz"
  sha256 "7c9cdde049e02433a94cbfc3e7efd2b2ff7b08b9e5343849069b896ea646e40e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9c592376ddcf9f8634ddae8c0fe80e8e50eec9bb33237e8706f6746f8fa5756" => :mojave
    sha256 "7e35bf909cf5ad90c317f6d5d73aa72caa767298ed773e21e203ba4635c253b8" => :high_sierra
    sha256 "3da3d3bbc6fbb235f789276e21144b76147ad5617c774cda798d78c8cb60994a" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/lsd #{prefix}")
    assert_match "README.md", output
  end
end
