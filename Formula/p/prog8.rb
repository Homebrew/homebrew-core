class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v11.2.tar.gz"
  sha256 "2e06e38c5b83c277a1671cd5d20e02373dfb4b52f8ec0064dc21f8e272b9edb3"
  license "GPL-3.0-only"

  depends_on "gradle" => :build
  depends_on "kotlin" => :build
  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installdist"
    mv "compiler/build/install/prog8c/lib", "compiler/build/install/prog8c/libexec"
    rm "compiler/build/install/prog8c/bin/prog8c.bat"
    inreplace "compiler/build/install/prog8c/bin/prog8c", "/lib/", "/libexec/"
    prefix.install Dir["compiler/build/install/prog8c/*"]
  end

  test do
    system "gradle", "test"
  end
end
