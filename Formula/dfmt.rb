class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.14.2",
      revision: "6a24f0dc7c490f4cb06cdc9d21b841bee84615f4"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf94fcdfd61ff2b0e7678629fa9b04123e3bdae96e1b7fdb060956c6f5b8fce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b861f187e5713461de50d3772babf2a56558e21e288ab7eb7084c2cf4f23931c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15bf7ef49901279546ee339c834722a87b3a940761fa534cf72f3dd2b4462430"
    sha256 cellar: :any_skip_relocation, ventura:        "2eba7a65251b0239b9615e188ec481ab27032a114317caba4de5ee2d718f85a4"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8838d064641d0d691fbf839cf384c16410012b679fdda9d32796ffa57734a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9854d6df204f9c15fcb6cbe9020f36b3b7132c90e32b9b11cdcda642800ae545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47f366c2db536367f33a3c6236ad83be77e7a101db900e7d7ca6d5967fbe23dd"
  end

  on_arm do
    depends_on "ldc" => :build
  end

  on_intel do
    depends_on "dmd" => :build
  end

  def install
    target = if Hardware::CPU.arm?
      "ldc"
    else
      ENV.append "DFLAGS", "-fPIC" if OS.linux?
      "dmd"
    end
    system "make", target
    bin.install "bin/dfmt"
    bash_completion.install "bash-completion/completions/dfmt"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<~EOS
      import std.stdio;

      void main()
      {
          writeln("Hello, world without explicit compilations!");
      }
    EOS

    system "#{bin}/dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
