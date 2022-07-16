class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.12.2",
      revision: "8761fa1e38c4461e0dda1782b859d46172cc3676"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdad16d21b13b420b6d3f51a5edac74a65bc3b6587fccb4035e7f286463132d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1647cc20df2c97376c99ecb6be4f82e16fe4587228741024cefe775278b5a86"
    sha256 cellar: :any_skip_relocation, monterey:       "8461f57853911057d829e5bff0cfe2abbdaa2a36ebb73e4c97f5fe3e633f989a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c178b23fbb7f83b7573cbb0baafe848e3ceefce2c701cdae694786111746b948"
    sha256 cellar: :any_skip_relocation, catalina:       "238fe917c7a62c9bda4f390349d870437775b3fa17a93fa685d2845a9670e40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf437aaf0802ae3aab2a37476e0506351b1da609c6470acded10962537a639b"
  end

  on_arm do
    depends_on "ldc" => :build
  end

  on_intel do
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
