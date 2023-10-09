class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.8.0.tar.gz"
  sha256 "496fb8cf8d533f3e9eaa64098c32499ba3c94eb51b1f52dd550948e8c612c1b6"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa762ed2c4b29e9cf3d3837853851145a408b0f65d61b7c2a28feb32949dd4ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6427abe5672af55ede5b6b42e320874284307cf073a98f00ae14acfca966457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20735dd0b9efdf70328b5dae305ef88d8aae8a424bcf02c65cffdbc8471fcb4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ac6521e84685f8419cb5deba01a108cd8c161363311cd47cb8c6331454b0f6"
    sha256 cellar: :any_skip_relocation, ventura:        "5497cc1358c2c777b188181e39e0faa3e6279b9c14645d83a3f10b91be16a01d"
    sha256 cellar: :any_skip_relocation, monterey:       "0a349ed1bdb20d6f8247400d6b6c2d45d00d6c61e2d4d35c94b668f81fea37f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "642ab90fc5f2dedfb91e76e0f976e10d80b8fe08ebb69418286e6dbea5630618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2657c67be0a4847531019017b23519216b8b0dca5c4aa4d73315e2b6ed976d"
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
