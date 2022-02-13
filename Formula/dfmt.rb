class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.14.2",
      revision: "6a24f0dc7c490f4cb06cdc9d21b841bee84615f4"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "b6f7197f2f1580bff0f06ed086ca679c310d87d64ed506ce8deb89fd49a7d514"
    sha256 cellar: :any_skip_relocation, big_sur:      "e558a7feb8739e2064851d66769050b26b8bab8bf009356a773cda5a39e924e4"
    sha256 cellar: :any_skip_relocation, catalina:     "3b322f9dbfb2062678b18e6e53719204446315e2fc70a788759505cdc663b839"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "852cdd41ee99f72be5b7e22af09e07a5da3457791016a78ec0038f3172c96120"
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
