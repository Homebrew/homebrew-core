class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      :tag      => "v0.7.0",
      :revision => "1bb815e927f23ca3420b61bbe53f7f06a1390c5a"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f793878bbdbe923afb93d1684c22be01d4d6098cd1c788e1c781b8ce9af48e76" => :mojave
    sha256 "cb52051082e2a8c05823be5628f978d943971bda688e9459b2958d0ff9d970ea" => :high_sierra
    sha256 "d76e986bf790b428b9a9fdef46e7a67457c726a0dcc2525d1fba2fc9ea4efe8d" => :sierra
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
