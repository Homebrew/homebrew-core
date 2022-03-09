class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.12.1",
      revision: "e027965176499b578b297e8bead32a0400d07a6d"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5d0c35d95ebfb026a56d523b754ce1d872cadcee2f7ea031459f929cb54755e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23838b253d81dc344dc222e4e3b020021cf1ccdfbc32ffae5458a9cbe0584f81"
    sha256 cellar: :any_skip_relocation, monterey:       "0d48ae238ece9f6e2919117e20ce07a9b9d3d02ef50e14397cff8688ecc7594c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8240e6a2d9f8f18e7a4d9a1f561b701181917745a867204a7449496b4bddfe4e"
    sha256 cellar: :any_skip_relocation, catalina:       "58984bf1dbe3703f5dab362774773d4ee7bbc7e87bc09939f825da2feaafc867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60efa9016af0bb078a47e3608a192d25203843166346caa27a6a71141b37a100"
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
