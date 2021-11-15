class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.14.1",
      revision: "b776d5a9b96df283ab93b19a9bc689d633bdcb83"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "da0e960bd1741a529663f4b7c3fcd406f77a0a9b75d99ada5f9c7e782df3acaa"
    sha256 cellar: :any_skip_relocation, big_sur:      "0f09cf9fb7712ebc83e152a9f91e8b1bb6999f08193e972fe1aff4d59086173e"
    sha256 cellar: :any_skip_relocation, catalina:     "2cb758724bd788db0b23c88e40855ffe8fe5f78e88d30f3913967d0a7358ad95"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43b3d9dbcf4f21e8cd20937505b13406b2643bba0f10c498b9046ad894e22966"
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
