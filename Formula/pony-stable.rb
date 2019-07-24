class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.2.1.tar.gz"
  sha256 "1335d7b3457421b8913f19c17da76d2d6b9ad17288dfb5fdcf2af9fd93193890"
  head "https://github.com/ponylang/pony-stable.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35714dcf19ff2245090f7651430cfb0c1216cc3e599e6cda7edb9b964db4be6f" => :mojave
    sha256 "77768ecada4cbab8da58ff06f639a43eec4cf1fbe328330dc0073971bdbacfc9" => :high_sierra
    sha256 "b04c2a2da1a13bb3cf965742c4c6228ccf8e7befbe734bd2f461633eaf6e46ba" => :sierra
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
    system "#{bin}/stable", "env", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
