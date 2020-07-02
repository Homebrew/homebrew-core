class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v4.0.0.tar.gz"
  sha256 "0ed64bea377199544b3d41560c9a72f7914434b32f97fe0221b5e43719121845"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4d4dbea6ca09df962c0d5773631d0c9ca2eea33968a453b7743e40cc8d16fbff" => :catalina
    sha256 "e7454e67d40ec10672c036a51d86affc67812d801597233d242d4893b41ea121" => :mojave
    sha256 "b9aa14bd8c6f7bdb5e5189888bf563f1c3d64be4944ac1fe843ed84c5ed99ebf" => :high_sierra
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
