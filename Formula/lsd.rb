class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.19.0.tar.gz"
  sha256 "11e2c925562142d224eaa1c0d4ddec23989e5b8af93a747fe61389fba02cf808"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4de553270f78d0760dffb2ae706df46baf1104379dd78c9fa88046bf024cdaaa" => :big_sur
    sha256 "01f7b9b3d821ccfdb495c2391b0f668f89b9e13df20ceb578f246761905a2361" => :arm64_big_sur
    sha256 "351d9ceef129e8b2c27f4f1c6c6edb60cecbb5db1785f350141494d67de4a1b9" => :catalina
    sha256 "b58b1b7fc1d76f81b5d089cdd8b8cdfbe876e4011231a4fe85107d935ae4ded6" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
