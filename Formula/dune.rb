class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.3.1/dune-2.3.1.tbz"
  sha256 "b2b3dd9cdfd34ef8c4583ea8c52c3503c2395bf94c264af19d6450547e12f5cb"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4011a6821b7dec0d069a3b7ba3592b0e255524587666af2da2dcc7181734e33c" => :catalina
    sha256 "ea0e4732220f3c4aff8d3596df6ec50d017cd97fe26578a291c7e90264fe5ba6" => :mojave
    sha256 "95a8f5f81decf3f31b690556c9d0606d738609b42aad99b712f92a36a211a3a3" => :high_sierra
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "ocaml", "configure.ml"
    system "ocaml", "bootstrap.ml"
    system "./dune.exe", "build", "-p", "dune", "--profile", "dune-bootstrap"
    bin.install "_build/default/bin/dune.exe"
    mv bin/"dune.exe", bin/"dune"
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
