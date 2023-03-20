class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.14.0",
      revision: "d5d6920502bf1bfdb29474007a59fd606df0aadc"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b103273d63236f1b0248e4ae49cc8222d20aaa0a1caea7868b9fc534c6ebb88d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa9de194ec0c6fc7eeaebc1b248246d2b6a277a90a90a750d15286b304696dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29961bc77ba4286bf0639b6d5820c1e6f2eaceed7acb8d33c1d745281ac20b7"
    sha256 cellar: :any_skip_relocation, ventura:        "42ef416a861cc5c3417280a2e9a174443f1e6d7f8b3643b10239d86417f33289"
    sha256 cellar: :any_skip_relocation, monterey:       "f536efe9c19e9487d576cd25a2c6327c5aacf2fb88e003941e5487b130b48448"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cdfbe7edce737e08e428c5cb8617c44b5a8ec433a51406654f0c4865a1f9a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f621b9b86043c107ff01833bc027bfa6e1a5f160fd987696dc85de4ca80441ce"
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
