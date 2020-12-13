class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.19.0.tar.gz"
  sha256 "11e2c925562142d224eaa1c0d4ddec23989e5b8af93a747fe61389fba02cf808"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8417ee9411ab2a26568a38df41c9b1378976fad62979c88faaddd07656ef3e6" => :big_sur
    sha256 "4d4006519356f1225dc9ea1cd2bb4c912769070ebd030db56a76c3936dd5a33e" => :catalina
    sha256 "5b197d19d9de997a5ad79a9438dd9358be5bf63a09555ef3eb7c077ea1760284" => :mojave
    sha256 "609cf3638d7e41abb52da00a5df801ae2d6faf76757e47a924d07c6f0b5361c9" => :high_sierra
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
