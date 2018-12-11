class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.11.1.tar.gz"
  sha256 "7c9cdde049e02433a94cbfc3e7efd2b2ff7b08b9e5343849069b896ea646e40e"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/lsd #{prefix}")
    assert_match "README.md", output
  end
end
