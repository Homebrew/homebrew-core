class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      :tag      => "v0.9.0",
      :revision => "6d91031302fd611cbb3ce36f9b7499ddc3cd2ce7"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e126b7c883e69957151817c0170cd3cfbab3e35788c54d9d94570fdd7c3924ed" => :catalina
    sha256 "2e01bcfd71923a8eddc1e9f5eade8b12106fd619ad0f7ff004cf3a26d59378a5" => :mojave
    sha256 "45e4022ceacab5d30dacb2cbe69db65a9079e5624cb0f54144abce50b014948c" => :high_sierra
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
