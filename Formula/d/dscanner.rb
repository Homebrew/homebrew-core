class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.15.2",
      revision: "1201a68f662a300eacae4f908a87d4cd57f2032e"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d6d40386c0ff0fe33e4a8d3a5c5a1c19ee21718dd17327adc815d4d60b3e087b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0f16a79d7fad72e96d08d3a0aaec16318064de06f115a875fe786f93c2ba872f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbd1f17d0cb48e71509362ee0705181a2f1b4afff17a52ae4390f04af43c4419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "135c33db9a535d0c6b1c4ad21899663d2cf20d15279421273d7ba81b548babcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7df8505b212231cd76276d1e11b9f9bd9794527cefb81ef077ac4d6e870b504"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e1b62ebf7c2955101c1d7d0aa933d594709eaada2dc9de080238f617a3cb73"
    sha256 cellar: :any_skip_relocation, sonoma:         "bada06186eb5dece5bd0e3f23a3b1d5746d0a179f66265d103ee61cee72179d9"
    sha256 cellar: :any_skip_relocation, ventura:        "5f9e5546dcccee737c540b09ddc4920c59a52f04f99a35d949ed1a42ec9475f0"
    sha256 cellar: :any_skip_relocation, monterey:       "64a56095f35e980d12527e2b42224755fc15f23f771995c5368db7b0012a694c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee3d570973017105d7f4803bd22677ed0b16f2e512545c13fec63c5f22581639"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6ad79f5597ccd3323e4de2a6ecfa9bcdd8e6b6b05e48386154d167f6e37bb81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1216ef19a42105de9617742024eca673eb221d711526bf6dd2204537a70afd34"
  end

  depends_on "ldc" => :build

  def install
    system "make", "all", "DC=ldc2"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~D
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    D

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
