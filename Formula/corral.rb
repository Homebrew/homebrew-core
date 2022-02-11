class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.5.tar.gz"
  sha256 "e124b6a217d159e7c2f09cde3e3d104c099163c54fe25ac1c546b059f575526b"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6066dc08270e5fd5e8473ab9ee1ca9e9ecb3d3b42367303a18fb2acb3ea0d07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "464d84862fa6acc8d0e0e64b303009085d89e0d2843ab93277cd677c33ec7961"
    sha256 cellar: :any_skip_relocation, monterey:       "b31f9be8bbe5f82dd0aaf71181b53a20d7937170136b7c8f5164f68f679ff3f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d19c2f5d569d9edfa877ba11d432d52c3f266bf17c9fbd08ffb423529fa3733e"
    sha256 cellar: :any_skip_relocation, catalina:       "0d697a6432496d52ae12c4eac0b49d29be6e2491b56befa0845e78cbe26759b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39fe4c4506de1f12ee78ac5e7ebc7f877d3c761c2d563e3b53a4f0ebcf6d8ef"
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
