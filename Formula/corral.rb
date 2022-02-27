class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.7.tar.gz"
  sha256 "5b7cffc54abe5b2292a2fb2c67603a52c0c02d38ab8bbd2af2af0b80ca62e414"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b389a70284f5f1da146d50765e4ff9267bd3b02b5206c38f3c072842c3cc9f2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "addcb1c6dff12839ebf340ec658aa1aadb9c4037160e09c419672e3cebd79b94"
    sha256 cellar: :any_skip_relocation, monterey:       "db06c3ca882a8a111c273671d574561c1644aaa72c20558e46fbbf9391cd1f91"
    sha256 cellar: :any_skip_relocation, big_sur:        "566c52bcb06f64ea9f526b1eab740cbbdbd6017c3b9add34c03388177cc930be"
    sha256 cellar: :any_skip_relocation, catalina:       "cee74a03702afdab7071744ac16aa0b433ba5edfc2273b42c6519be760cc4159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f68ec51f4514b2ec9ad9d729d045b3f6df92952e25cd527723e47c326dcb1f69"
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
