class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.3.tar.gz"
  sha256 "caee35ca820201c13b87e11224ede472d1ed9798985d17eee8c46b14711f7d07"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "8bf55316637ccd844945fb01255fd17adc6c32450468ce0f4fa6419c3fb721d7"
    sha256 cellar: :any_skip_relocation, catalina:     "01fe7de9d69e7a37b2c1a246efc666c0ebc472e50e541dfd5f998861b9abd808"
    sha256 cellar: :any_skip_relocation, mojave:       "89f5021d6f6ac5a1b92a6c622788dabe904fd16d631ae6546540171eafd2b671"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2468019691e114d92f96bddff1532c5a8e7129d6b0d65314386590cf50786596"
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
