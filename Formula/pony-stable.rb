class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.2.1.tar.gz"
  sha256 "1335d7b3457421b8913f19c17da76d2d6b9ad17288dfb5fdcf2af9fd93193890"
  head "https://github.com/ponylang/pony-stable.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7da637b58849f22f8ff032854b405eb5a7c32ea3603b524146e4cf24f67ded1c" => :mojave
    sha256 "a81295a6570890eb1b6ae816a80d58ffa8960858efbd4744a8ec7bd22986eadc" => :high_sierra
    sha256 "7e6c0e27461f443549eeaad7430ccee0fc8b833acf5c9658255de4d5dcd52b21" => :sierra
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
