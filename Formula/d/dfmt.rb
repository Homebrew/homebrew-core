class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.15.1",
      revision: "470e65f7cc19441c4d50932520aefb7d93f242d5"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fdcf8d6abe92da0779370868eb8cd46437bc88705ba963361b5deeb0466e4ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42099cdc494464ad1b203c242a7144f0d0147f4f948644986f6437f05248d4bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a284a73ce3996487787a8aeb084b951e6e4523342bc87e484f84de61d66cd040"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba1872f353a3ffec3c558edc7c89b82ddb8701a8d5d599b6520633bedb916a0"
    sha256 cellar: :any_skip_relocation, monterey:       "2e3b7afee0e3a199b364181e973a79991c82df1dbea3bd827ea7ef1442760dbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0f852a6e158291f6203fdc20eb2c1b8053518ee8028b04f6da330f37e1ae2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92db6ca03196895c6c144303402a38ffa5e0455489d600ed715f8442c77fa602"
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
