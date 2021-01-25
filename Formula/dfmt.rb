class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.13.2",
      revision: "7659b1ae1aaaeda6b787ec60a2ed1e902326d5a0"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "e4f4475c66dccc8466a59a829e64ca18d5f28f25c882cdb4851b7f60dbac8bbe" => :big_sur
    sha256 "316ce1c0504cf87bd8de9bb045fd855e887c75132993bcbde37d1bf54c9f00d5" => :catalina
    sha256 "0644eb26171306e6e76606c373cda1f641c8afcc91f6c8852521e89a49b69864" => :mojave
    sha256 "9edcdbe4f7bf57c0c79ee7bac6f29c4ca1882bf41ec86564e1f3abb35e48c44d" => :high_sierra
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
