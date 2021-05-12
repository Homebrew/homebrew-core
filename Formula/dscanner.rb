class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.11.1",
      revision: "7809598da0e06a319d35d3b6edb4277710fa776b"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "e88d2f23ed2dac725bd2fb4984f7c5271136054beeb32d261c634d2c892cacf0"
    sha256 cellar: :any_skip_relocation, catalina:    "21c95d6cad0fa39bb72a762b371858bda0553a6520cffc4f7ab10114d9799366"
    sha256 cellar: :any_skip_relocation, mojave:      "35f721658f883a3eea9a2d979e31b8cb67ecf0f62a78112daa27a2c5c9ef4516"
    sha256 cellar: :any_skip_relocation, high_sierra: "ae2a741fe6d195a79dd24ccce02afa7693742fee9454ad1d0f97c50c512a62a5"
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
