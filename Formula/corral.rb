class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.6.1.tar.gz"
  sha256 "25a5f25e4e448ad7adb33f2200ba6b6295c4fc60398f0fbe2c8e4923b10940d4"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d4aed854a842fa9b90d3432977bfbc2c0dab679aa47bc5fbd06e008c5b0e79b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29bb85039ca61a8285288ea2164804f5080606be32c2f2e565087b0264bb5b39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ead180d0fa14eb339b66d21561881e062da053735adc81103cb6fdbe0065fca2"
    sha256 cellar: :any_skip_relocation, ventura:        "ecab557f3ed4061172220098f752dcf19df7850c7c92c93c4662b4f30345854e"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf6fe6f11477af16eb18a8ace2c03631226b114fd789d509a4a72d1e41e1075"
    sha256 cellar: :any_skip_relocation, big_sur:        "a44be086d20d74c119d1cd236a51f7e905b9960acafcda6ccc92d865a26e832b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861421158f38aa60bc7cefa4b6cc2303805c93040a58a44fb1fa15acd0416c73"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
