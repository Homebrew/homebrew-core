class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.6.0.tar.gz"
  sha256 "d1e4cfd07c170780595b4681ad444faf69892d59adec4a51b02ede5641a4fdd2"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1b65d56f0f4bb6014f7b678b7ef5fecef1ed93bf5dea0bb1a7b377fae853e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d39b4d07553e5341bd076d55e94f01dbb7ae0ad96a898124841ea6144e369e1a"
    sha256 cellar: :any_skip_relocation, monterey:       "42c47daa92162fbe3b478ed8ea365a9e4a4733edc49becc3ba2eadafe98c5313"
    sha256 cellar: :any_skip_relocation, big_sur:        "c33c460ce05fc30ffca5c35b03192c7a7aa52f09586aba73f38feb065ed6110f"
    sha256 cellar: :any_skip_relocation, catalina:       "472862d6c81ffeef5d98d176e31137fd14f56737ed4b60ca2d874300d7d60b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57fcc9fca4be1410ef18d69f7ce1c22c31d88cfefea8e74dde86663a8821fe3f"
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
