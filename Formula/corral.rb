class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.4.tar.gz"
  sha256 "ca2fff8568fd14404d25de402dec2cae16cad39edb7937f829f88a23a66da2d1"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b223b7ffbe3f36302c029b110a5c6292270e4e27795b55a0ea5510664ba8ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2e834fce3e5975278473b0b4feae20fa018e2e69c98b2830de3957117d58bea"
    sha256 cellar: :any_skip_relocation, monterey:       "3692383008fe80f3863cfaf1411ab589d79fa44a591d8da750b67a5c4585455d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdd3bdc4acaeab7247b76aa1dbe3b319c1a512c2d066ca41d30c03aa69dfef0b"
    sha256 cellar: :any_skip_relocation, catalina:       "8faf06cfba7afa9efee5505a50b3c2490ea2f501085f8a5880dbd00a1f1b6997"
    sha256 cellar: :any_skip_relocation, mojave:         "c9bec6571d663be1e46a599d5d99ae273f25816e8c19a1857f46f9652344cbb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f29be05b07b7466d2a75035c19f3b7c781a5d14db250f32fc4aa8ca958c4e6"
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
