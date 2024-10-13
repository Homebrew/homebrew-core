class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/refs/tags/0.8.1.tar.gz"
  sha256 "a6c95833ec4bd0fcdc2ba5dd3f5ab509c0a500a086f6be8df22f28c752148dc1"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5cf45220c4c9b518a043fd6b79afb77619f9f9f85f3920b64938c10bc8987203"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47042034b51889ffb4e5c8e2e39bc6bee3b07913df912830e1ce7be697884de2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e777fcf9a0d25fe2c433d1585abe5364313d83d17b479fc2ceba6f70f1fec08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02719312b46a15d2f5adc1bb9c1f7358f65c564e5a6106d36ff69c8ca28d2089"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3c26add1c6b56e36bbc4ae18dd54f5526bdb87a6f3a6eec0cb736448a824028"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0c150865035cd34404a2601389ce91844b4ca41e4e56b3272a6563fb0f0e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "9402ef0ff8a3b4a3363dd5b5d025139cd5a01890ddea26ad2614abc2171286c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441af9edd92535db5a01d1c913744be72a7c9de65150a61aa6e3d23cb61451da"
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
    system bin/"corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
