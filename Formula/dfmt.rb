class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.15.0",
      revision: "49b9fe4051579bdcc7fc155bee6a43f3ab7174df"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd055cfbce99c8b142b145b6891e1934954e0474cb48788a59e267c47a22ea5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "531018a5c33d27c24e1f1748ab4348d3ff5ebd1273ba0190e191d72855ac75c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fbd4f35552d83ce0576ff2593dfd8c47eb4db0890876ce2915fedf2b4c597a5"
    sha256 cellar: :any_skip_relocation, ventura:        "c6d928757ccc23f1ac3332198fe639a6eebd968182ad0ef7bf0dd5d58552b09f"
    sha256 cellar: :any_skip_relocation, monterey:       "91ce9ed7424595d0fac0de667b067119a5e75454cc0902cbb8f2fd665f6351ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e47c0481d8a5850eb4377902df9c6ce79efe785701ab22f077fd6e1e96aa5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b66253ada544ae0dda30aaebbb07158a6d364d1d34c9556eb5613e7390c4259e"
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
