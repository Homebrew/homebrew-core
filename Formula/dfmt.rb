class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.7.0",
      :revision => "4168c232ab9b3698afc891a72767fc97c83345df"

  head "https://github.com/dlang-community/dfmt.git", :shallow => false

  bottle do
    sha256 "3dfefbc60943f46797570674bc8300a1dc42fa6b58a26bdc6db2093019070d18" => :high_sierra
    sha256 "f2f502de2c66816f330d6d17aa250e460de293a071d9ba7ecb08a4a11145a6e6" => :sierra
    sha256 "35b25d36e324e797a07d91a2af5d82a8a9aa5bcacb76a3375eabdd261861b74a" => :el_capitan
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
