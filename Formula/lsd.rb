class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.16.0.tar.gz"
  sha256 "e2406748d78431a1c03bdd2404a204a006c19905d926e41a36587b93a791e003"

  bottle do
    cellar :any_skip_relocation
    sha256 "4107ab0f07cb55f9a27393f31917deae3c144c82a106ee62672398e8ab405688" => :catalina
    sha256 "9cf1be00bfe0f3f7d0142dd1d1f4118be58415f7a8444ff194a5f919a3dd03c9" => :mojave
    sha256 "1017f694172dec6120c2d49277268ee21f417a363c55a880541c1119bd82fc4e" => :high_sierra
    sha256 "93be9faa9b2a58a509f7d53a78ce1950bc3a770a13cffdc0980a329b97f14a5f" => :sierra
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
