class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.14.0",
      revision: "d5d6920502bf1bfdb29474007a59fd606df0aadc"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf97055e28d37f7ec405b2b74d8df2dbd81592bf949b4b314e9d1dc349670c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84350066676dcd3809188dfc10b55478f65bacc819f64b202d14bee6d402e85a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c183c51804c63baccb3a326d63a950f897a896e4286aa8ee23da4d30f2da737"
    sha256 cellar: :any_skip_relocation, ventura:        "0b49192fb45fd1b0340d39ef82d1590683d76199f73ea218c315fe84539a268f"
    sha256 cellar: :any_skip_relocation, monterey:       "69e8d5ceced1e610d29888ea9d68e57d212f87eb259852fb53e7c840df0f81e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "add5c81f3f83f509909a4ad2f3e04cbf659fec27340e0b32f41893867e5c1859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d650b1923faf383be1733c311b61f9dbc7c0b7817655c00ff42a49439815da"
  end

  on_arm do
    depends_on "ldc" => :build
  end

  on_intel do
    depends_on "dmd" => :build
  end

  def install
    # Fix for /usr/bin/ld: obj/dmd/containers/src/containers/ttree.o:
    # relocation R_X86_64_32 against hidden symbol `__stop_minfo'
    # can not be used when making a PIE object
    ENV.append "DFLAGS", "-fPIC" if OS.linux?
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
