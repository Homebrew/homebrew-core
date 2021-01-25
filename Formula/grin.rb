class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.0.1.tar.gz"
  sha256 "cfa60340f941fef8fd80ff7f2db62659ce2a581163603f921a5c401f70fd4f9d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "23508e8aeb1f492d02cab86a37ee13a01b7c91e51ba9f99915bb290168aa65e3" => :big_sur
    sha256 "614b5706b1411d4fe034892ebd04757c8130dce05c839bb49c530ef35aff7c18" => :catalina
    sha256 "367c827e429afa3bff4c03f2c272d8e6b18346eda070994afe32230a6f3f59da" => :mojave
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
