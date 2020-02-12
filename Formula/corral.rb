class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.3.1.tar.gz"
  sha256 "ab6fc435db5726a3ea68c8364f3de665551825e5dd58c06ce19576ef7266e602"
  head "https://github.com/ponylang/corral.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fe16cd9f427551d22028457f9571f666053c4b39a528543e68a917643427a41" => :catalina
    sha256 "3fe16cd9f427551d22028457f9571f666053c4b39a528543e68a917643427a41" => :mojave
    sha256 "449fd9454d9e5272a30d9ea909e506638c5e7d633c1c7d683f2592ce7e9fc487" => :high_sierra
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
