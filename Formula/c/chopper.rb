class Chopper < Formula
  desc "Filter and trim long-read sequencing data by quality and length"
  homepage "https://github.com/wdecoster/chopper"
  url "https://github.com/wdecoster/chopper/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9193c545fca75eb580b0d04f2434fa2f36fbb6a95969c38956546ba0aaac0576"
  license "MIT"
  head "https://github.com/wdecoster/chopper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2da445b34e705eb275c041c09dbbaba477589fb44cfdfd5ab0323e884a6044e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf94e9510a482e0c5c3f53b2f98b919a7dabe03ceecaaedcd27ff9cf1995bf6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9134d08fd6e25bfe15149d6c72302ddb77692d1650a99cb09b7c0a419c598af4"
    sha256 cellar: :any,                 arm64_linux:       "d453e22fa8c541a560e4b39cc976f3e540fde59dfe5d84f0e63deb958f0d8059"
    sha256 cellar: :any,                 x86_64_linux:      "4368ac9b3050ca90d9edf9a9c85caa6716119f9897a03f470d3af87b2d4be04f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # read1 is 32 bp, read2 is 4 bp; filtering for reads >= 10 bp drops read2
    (testpath/"reads.fq").write <<~EOS
      @read1
      ACGTACGTACGTACGTACGTACGTACGTACGT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
      @read2
      ACGT
      +
      IIII
    EOS

    output = shell_output("#{bin}/chopper -l 10 -i reads.fq")
    assert_includes output, "read1"
    refute_includes output, "read2"
  end
end
