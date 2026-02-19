class Exomizer < Formula
  desc "File compressor optimized for decompression in 8-bit environments"
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-3.1.2.zip"
  sha256 "8896285e48e89e29ba962bc37d8f4dcd506a95753ed9b8ebf60e43893c36ce3a"
  license all_of: [
    "Zlib",
    "GPL-3.0-or-later" => { with: "Bison-exception-2.2" },
  ]
  head "https://bitbucket.org/magli143/exomizer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56448e95a835779566679e80a082ca12284cf6412a299194e363f7f06bb0440d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a5cf305a6a643351a6335ce2555628f9448b9010009475e77ffa6d8a54b441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7292bb3eeaffac34f6540a029f6e21b79089b66e498d9e3bfa611cd44189b48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e4a5b210dbdfaca2b71eb4c5d78401e5029667d6be88fe44d7aad0c2f4abc1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cdb28fa2ff68d518ed22b2399155c532059e2145753ff10cd9a9f201fb46632"
    sha256 cellar: :any_skip_relocation, ventura:       "dfc125e3ac9f7799f2a733c9b24e9270751f8d4091ab12d9bf5ae1247c76a612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ab5a0efdf18a785bba4bc1ee6216b141a664d0515b261e93abb0af6943891c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0fae099202b6a7ca59dd64e37fc4ffbe8f4612b2b4dd9e266053a7810c9bdac"
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[exobasic exomizer]
    end
  end

  test do
    (testpath/"test.txt").write("Hello World! Hello World! Hello World! Hello World!\n")
    system bin/"exomizer", "raw", "test.txt", "-o", "compressed.exo"
    system bin/"exomizer", "raw", "-d", "compressed.exo", "-o", "expanded.txt"
    assert_match "iHelo", File.binread("compressed.exo")
    assert_match File.read("test.txt"), File.read("expanded.txt")
  end
end
