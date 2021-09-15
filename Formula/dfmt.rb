class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.13.4",
      revision: "e79ba9f0c89ee39f32780c5a2fcd2294b1040190"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "00eceeab6157c27c75002f5239183b3902071c0aefe0b8892831115897edf197"
    sha256 cellar: :any_skip_relocation, catalina:     "a545590d0222235eb45c81f82d62b66a26aeb2156217d2c010bbb6b90201fd26"
    sha256 cellar: :any_skip_relocation, mojave:       "27d62a6329e0c0b3d3e18d05600ad4fecf6dcd1cdd07eb150e292df593c7d92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "74d9f0c77732a63098658c8853dc2340cabcdca1ac7382d104f58474c21f7771"
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
