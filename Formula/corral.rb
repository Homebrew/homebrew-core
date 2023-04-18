class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.6.1.tar.gz"
  sha256 "25a5f25e4e448ad7adb33f2200ba6b6295c4fc60398f0fbe2c8e4923b10940d4"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da9faf739879642037dc5a79ed5df5ccff7e071f50ef800e8068e43a1de4c9b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772445f9b958123a6a960e41a49454069478b0695463cde110e871f090c8a62b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "665badb68285137edf704fa1ccca3bc51170dec05f4c11c14efc133c7b88eb78"
    sha256 cellar: :any_skip_relocation, ventura:        "cc172354a4048f652d077704ada8bdd6ad1ba3bbbe1ac66ce9e8208163b60100"
    sha256 cellar: :any_skip_relocation, monterey:       "3d8e11aae4992d8a98faf253949180157ca51a97bdb03de300679503cecd4deb"
    sha256 cellar: :any_skip_relocation, big_sur:        "61ff5eb7a2a590486061318048865b8ba0cfd4fd8abad4f74ae8de5b1e2da3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a60e740d26083b127df286d6054b2b126ab5d894ffe4e0673a1071e2bdd8096"
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
