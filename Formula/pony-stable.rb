class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.2.2.tar.gz"
  sha256 "8fca5f0f600e695d648200a7492c5d8cea82581f4e4e138f0bb621911d9e4c13"
  head "https://github.com/ponylang/pony-stable.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1375ab1923d90e07e05071bad1effb66aef547bd6d9fd98a40afbdb65596471e" => :catalina
    sha256 "1375ab1923d90e07e05071bad1effb66aef547bd6d9fd98a40afbdb65596471e" => :mojave
    sha256 "caf0c823ba581ab0e669d0372c06d1cb74262f05334814a5f49370659aa030d1" => :high_sierra
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
