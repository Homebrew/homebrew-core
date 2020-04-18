class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag      => "v0.12.0",
      :revision => "09caf255e537ea832a87c9aeb7ec4ed38d751300"
  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "201eb36e0b6461b52ec774f665665660eba0f757a2af342ab76849bcb4252c9d" => :catalina
    sha256 "707ba50ad974af797a50ed7470a8b53254b6882bf32d338861987df190fdddd9" => :mojave
    sha256 "247777bbba22b6934b2be5223cc234d46b42f97777781818b6cd8b2508dcc52b" => :high_sierra
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dfmt"
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
