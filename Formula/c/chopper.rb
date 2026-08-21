class Chopper < Formula
  desc "Filter and trim long-read sequencing data by quality and length"
  homepage "https://github.com/wdecoster/chopper"
  url "https://github.com/wdecoster/chopper/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f5df330e68e76ceb62f33338be7f7c21bd876e2ad84baa9e50ecbcfdfbd9d232"
  license "MIT"
  head "https://github.com/wdecoster/chopper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c835741bd35d334fbacb1e28830740c2754dba4b2c6a7001c64da088135beb1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e2020b75cb62b58f351fcef525925fd9bd153d4bf6243cc9a0d48a37c8266e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f76861d8e2f717c0b9f4d441cf6af01ad8419412f11ec263c95b2c4de73fb47"
    sha256 cellar: :any_skip_relocation, sonoma:        "87fb3e532cbaf141839681fc9ecf74f20652b76e301f962d005cc5e4c6d1785c"
    sha256 cellar: :any,                 arm64_linux:   "8b809d09c25541dd76bb83286a931243fab064e6cb077e628f36f1e684e692e2"
    sha256 cellar: :any,                 x86_64_linux:  "e1ae22b6a580020f5a1b72be1e502da1de05df47668b69d417dced7876b478a9"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
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
