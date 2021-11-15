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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4702973771c36c5600662a537e317c6bc33f3e968df217799273ec8930e662f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04671c602275ab8d9bcf8525b94653f1953485cbb0b8a0da5fd9710b1e8125e3"
    sha256 cellar: :any_skip_relocation, monterey:       "03660a8c66110b0e2216dce9e28b15a0f668de09644bd273426fd34635055d8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a9f50588d2e816c45bcb162f03af288b86cc685eeffed746ae1fa3270c8ee2"
    sha256 cellar: :any_skip_relocation, catalina:       "ea8b25fc75d04973f1b9d19fbc667ddef74c452321a17bf72e705a401225956c"
    sha256 cellar: :any_skip_relocation, mojave:         "7724e05645b4567b4e464c14d1631e5bd99381602d8a24442beeb72db0483732"
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
