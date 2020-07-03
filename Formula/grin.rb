class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v4.0.0.tar.gz"
  sha256 "0ed64bea377199544b3d41560c9a72f7914434b32f97fe0221b5e43719121845"

  bottle do
    cellar :any_skip_relocation
    sha256 "6853b963721e30472a1d939c87d373dd150b8d55eb73712c51b99d883a85d34a" => :catalina
    sha256 "87e605492972be68df5d540b630dfb343177aab67078fe9b878717c0d7288785" => :mojave
    sha256 "334ee1dc41d566f07bc38a0506857f3b34cb8d2e2512d437b13dd39bf23bebd3" => :high_sierra
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
