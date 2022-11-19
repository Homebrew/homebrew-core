class Fst < Formula
  desc "Represent large sets and maps compactly with finite state transducers"
  homepage "https://github.com/BurntSushi/fst"
  url "https://github.com/BurntSushi/fst/archive/refs/tags/fst-bin-0.4.2.tar.gz"
  sha256 "15eca6442021c7a4eeb64891515b9fe6cef7cf3f39eb72fb02042c90cae8ae1f"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/fst.git", branch: "master"

  livecheck do
    url :stable
    regex(/^fst-bin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b63e88f373219dbffc9152126a3ad5b6e7622042e57afc01de260ed300217f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7647c09e81d45d06eff18ddda7ea3aee56873baacd88cea01845d6d233a06a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed10e637357437f215e55b1070d78a55eb76736ecd26f283a5097a0a547856b"
    sha256 cellar: :any_skip_relocation, monterey:       "17cc8d03046d553a7ccf5d1ca49788edad2ef996e6ed3b16185d1f0bb3627599"
    sha256 cellar: :any_skip_relocation, big_sur:        "7160bf5eea7f95abb9045e0c6f2539325ba106863834aa105c29f754aa6489f9"
    sha256 cellar: :any_skip_relocation, catalina:       "38de7bf2581e11b619d8aa68e7d0b8d1a6969ec134d576efb2496267f1aef896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cc60019c5cf01d17c4001f49513eaa189cc4b4cb69dc2c0a0bf4d60beaa3949"
  end

  depends_on "rust" => :build

  def install
    cd "fst-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"map.csv").write <<~EOF
      four,4
      one,1
      twenty,20
      two,2
    EOF
    expected = <<~EOF
      twenty,20
      two,2
    EOF
    system bin/"fst", "map", "--sorted", testpath/"map.csv", testpath/"map.fst"
    assert_predicate testpath/"map.fst", :exist?
    system bin/"fst", "verify", testpath/"map.fst"
    assert_equal expected, shell_output("#{bin}/fst grep -o #{testpath}/map.fst 'tw.*'")
  end
end
