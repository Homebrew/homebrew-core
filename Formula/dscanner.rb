class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.12.1",
      revision: "e027965176499b578b297e8bead32a0400d07a6d"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "56a476c84db1007ff97be57ee3ed13c4f36f82cb7534850cc7f6f282cccf7dd5"
    sha256 cellar: :any_skip_relocation, big_sur:      "7ceae49df874f59fa2f86cb46f59d85f9d0df6525eac979442bf2be3dccafbea"
    sha256 cellar: :any_skip_relocation, catalina:     "1907fe417ebf7472cb6aadddca739500a99221fee4a16a8d62f42b368cfcfb59"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8dc52ce3f3a82d9eba76280c8cbfc70a08227288cd05cf2c829cc32b76662fdc"
  end

  if Hardware::CPU.arm?
    depends_on "ldc" => :build
  else
    depends_on "dmd" => :build
  end

  def install
    system "make", "all", "DC=#{Hardware::CPU.arm? ? "ldc2" : "dmd"}"
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
