class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.4.2.tar.gz"
  sha256 "3185ae01abdcb16edcbc19d561d167fee410bf09e53bbeb0fed7c0b95146e8c0"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "9b378d0793448c2d5ecf703f8915df5cbf4b1fd071fc032d8edc81a39740600a"
    sha256 cellar: :any_skip_relocation, catalina: "bfcfe42cf0a50c636d8f5e8e6e69130fd2038c7321987fca00f691da854cef3a"
    sha256 cellar: :any_skip_relocation, mojave:   "ffcbe9c301b1f6376fc7041e4b805b95c07443c34c9e320e5c73bbf5573fe67d"
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
